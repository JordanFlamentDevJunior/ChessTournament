using Microsoft.Data.SqlClient;
using Models.Gender;
using System.Data;

namespace DAL.GenderRepository
{
    public class GenderRepository : RepositoryBase, IGenderRepository
    {
        private readonly SqlConnection _connection;

        public GenderRepository(SqlConnection connection) : base(connection)
        {
            _connection = connection;
        }

        #region GetAll
        public async Task<IEnumerable<GenderFull>> GetAll()
        {
            List<GenderFull> reponse = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Gender", _connection);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                GenderFull gender = new()
                {
                    IdGender = reader.GetByte(reader.GetOrdinal("Id_Gender")),
                    NameGender = reader.GetString(reader.GetOrdinal("ValueGender")).Trim().ToLower()
                };
                reponse.Add(gender);
            }
            await ConnectionResetAsync();
            return reponse.AsEnumerable();
        }
        #endregion

        #region GET BY ID
        public async Task<GenderFull> GetById(byte id)
        {
            GenderFull reponse = new();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT * FROM Gender WHERE Id_Gender = @IdGender";
            cmd.Parameters.AddWithValue("@IdGender", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                reponse = new GenderFull()
                {
                    IdGender = reader.GetByte(reader.GetOrdinal("Id_Gender")),
                    NameGender = reader.GetString(reader.GetOrdinal("ValueGender")).Trim().ToLower()
                };
            }
            await ConnectionResetAsync();
            return reponse;
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddGender gender)
        {
            byte newId = 255; // pur indiquer une erreur par défaut

            SqlCommand command = new SqlCommand("[dbo].[AddGender]", _connection) // refaire procédure
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@ValueGender", gender.NameGender.Trim().ToLower());

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            await using (SqlDataReader reader = await command.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync() && !reader.IsDBNull(0))
                {
                    newId = reader.GetByte(reader.GetOrdinal("Id_Gender"));
                }
            }

            await ConnectionResetAsync();
            return newId;
        }
        #endregion

        #region DELETE
        public async Task<bool> Delete(byte id)
        {
            bool response = false;
            using SqlCommand command = new SqlCommand("[dbo].[DeleteGender]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@Id_Gender", id);

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