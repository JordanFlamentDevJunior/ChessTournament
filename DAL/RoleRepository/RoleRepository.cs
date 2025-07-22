using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Role;
using APITournamentException;
using Microsoft.Data.SqlClient;
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
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            List<RoleFull> response = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Role", _connection);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                RoleFull role = new()
                {
                    IdRole = reader.GetInt32(reader.GetOrdinal("Id_Role")),
                    NameRole = reader.GetString(reader.GetOrdinal("ValueRole")).Trim().ToLower()
                };
                response.Add(role);
            }

            await ConnectionResetAsync();
            return response.AsEnumerable();
        }
        #endregion

        #region GetById
        public async Task<RoleFull> GetById(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            RoleFull response = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Role WHERE Id_Role = @id", _connection);
            cmd.Parameters.AddWithValue("@id", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                response = new RoleFull()
                {
                    IdRole = reader.GetInt32(reader.GetOrdinal("Id_Role")),
                    NameRole = reader.GetString(reader.GetOrdinal("ValueRole")).Trim().ToLower()
                };
            }

            await ConnectionResetAsync();
            return response;
        }
        #endregion

        #region Add
        public async Task<int> Add(AddRole role)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            int id = -1;

            SqlCommand cmd = new SqlCommand("[dbo].[AddRole]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            SqlParameter outputParameter = new SqlParameter("@Id_Role", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };
            cmd.Parameters.AddWithValue("@Name_Role", role.NameRole.Trim().ToLower());
            cmd.Parameters.Add(outputParameter);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            cmd.ExecuteNonQuery();
            id = (int)outputParameter.Value;

            await ConnectionResetAsync();
            return id;
        }
        #endregion
        #region Delete
        public async Task<bool> Delete(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            bool response = false;
            SqlCommand cmd = new SqlCommand("[dbo].[DeleteRole]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Role", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            int rowsAffected = await cmd.ExecuteNonQueryAsync();
            if (rowsAffected == 1)
                response = true;

            await ConnectionResetAsync();
            return response;
        }
        #endregion
    }
}