using Microsoft.Data.SqlClient;
using Models.Status;
using System.Data;

namespace DAL.StatusRepository
{
    public class StatusRepository : RepositoryBase, IStatusRepository
    {
        private readonly SqlConnection _connection;

        public StatusRepository(SqlConnection connection) : base(connection)
        {
            _connection = connection;
        }

        #region GetAll
        public async Task<IEnumerable<StatusFull>> GetAll()
        {
            List<StatusFull> reponse = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Status", _connection);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                StatusFull status = new()
                {
                    IdStatus = reader.GetByte(reader.GetOrdinal("Id_Status")),
                    NameStatus = reader.GetString(reader.GetOrdinal("Value_Status")).Trim().ToLower()
                };
                reponse.Add(status);
            }
            await ConnectionResetAsync();
            return reponse.AsEnumerable();
        }
        #endregion

        #region GetById
        public async Task<StatusFull> GetById(byte id)
        {
            StatusFull reponse = new();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT * FROM Status WHERE Id_Status = @IdStatus";
            cmd.Parameters.AddWithValue("@IdStatus", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                reponse = new StatusFull()
                {
                    IdStatus = reader.GetByte(reader.GetOrdinal("Id_Status")),
                    NameStatus = reader.GetString(reader.GetOrdinal("Value_Status")).Trim().ToLower()
                };
            }
            await ConnectionResetAsync();
            return reponse;
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddStatus status)
        {
            byte newId = 255; // pur indiquer une erreur par défaut

            SqlCommand command = new SqlCommand("[dbo].[AddStatus]", _connection) // refaire procédure
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@ValueStatus", status.NameStatus.Trim().ToLower());

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            await using (SqlDataReader reader = await command.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync() && !reader.IsDBNull(0))
                {
                    newId = reader.GetByte(reader.GetOrdinal("Id_Status"));
                }
            }

            await ConnectionResetAsync();
            return newId;
        }
        #endregion

        #region Delete
        public async Task<bool> Delete(byte id)
        {
            bool response = false;
            using SqlCommand command = new SqlCommand("[dbo].[DeleteStatus]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@Id_Status", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            int rowsAffected = await command.ExecuteNonQueryAsync();
            if (rowsAffected == 1)
            {
                response = true;
            }

            await ConnectionResetAsync();
            return response;
        }
        #endregion
    }
}