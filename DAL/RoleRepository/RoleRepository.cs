using Microsoft.Data.SqlClient;
using Models.Role;
using System.Data;

namespace DAL.RoleRepository
{
    public class RoleRepository : RepositoryBase, IRoleRepository
    {
        private readonly SqlConnection _connection;

        public RoleRepository(SqlConnection connection) : base(connection)
        {
            _connection = connection;
        }

        #region GetAll
        public async Task<IEnumerable<RoleFull>> GetAll()
        {
            List<RoleFull> reponse = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Role", _connection);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                RoleFull role = new()
                {
                    IdRole = reader.GetByte(reader.GetOrdinal("Id_Role")),
                    NameRole = reader.GetString(reader.GetOrdinal("ValueRole")).Trim().ToLower()
                };
                reponse.Add(role);
            }
            await ConnectionResetAsync();
            return reponse.AsEnumerable();
        }
        #endregion

        #region GetById
        public async Task<RoleFull> GetById(byte id)
        {
            RoleFull reponse = new();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT * FROM Role WHERE Id_Role = @IdRole";
            cmd.Parameters.AddWithValue("@IdRole", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                reponse = new RoleFull()
                {
                    IdRole = reader.GetByte(reader.GetOrdinal("Id_Role")),
                    NameRole = reader.GetString(reader.GetOrdinal("ValueRole")).Trim().ToLower()
                };
            }
            await ConnectionResetAsync();
            return reponse;
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddRole role)
        {
            byte newId = 255; // pur indiquer une erreur par défaut

            SqlCommand command = new SqlCommand("[dbo].[AddRole]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@ValueRole", role.NameRole.Trim().ToLower());

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            await using (SqlDataReader reader = await command.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync() && !reader.IsDBNull(0))
                {
                    newId = reader.GetByte(reader.GetOrdinal("Id_Role"));
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
            using SqlCommand command = new SqlCommand("[dbo].[DeleteRole]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@Id_Role", id);

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