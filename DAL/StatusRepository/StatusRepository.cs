using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Status;
using APITournamentException;
using Microsoft.Data.SqlClient;
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
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            List<StatusFull> response = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Status", _connection);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                StatusFull status = new()
                {
                    IdStatus = reader.GetInt32(reader.GetOrdinal("Id_Status")),
                    NameStatus = reader.GetString(reader.GetOrdinal("ValueStatus")).Trim().ToLower()
                };
                response.Add(status);
            }

            await ConnectionResetAsync();
            return response.AsEnumerable();
        }
        #endregion

        #region GetById
        public async Task<StatusFull> GetById(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            StatusFull response = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Status WHERE Id_Status = @id", _connection);
            cmd.Parameters.AddWithValue("@id", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                response = new StatusFull()
                {
                    IdStatus = reader.GetInt32(reader.GetOrdinal("Id_Status")),
                    NameStatus = reader.GetString(reader.GetOrdinal("ValueStatus")).Trim().ToLower()
                };
            }

            await ConnectionResetAsync();
            return response;
        }
        #endregion

        #region Add
        public async Task<int> Add(AddStatus status)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            int id = -1;

            SqlCommand cmd = new SqlCommand("[dbo].[AddStatus]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            SqlParameter outputParameter = new SqlParameter("@Id_Status", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };
            cmd.Parameters.AddWithValue("@Name_Status", status.NameStatus);
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
            SqlCommand cmd = new SqlCommand("[dbo].[DeleteStatus]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Status", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            int rowsAffected = await cmd.ExecuteNonQueryAsync();
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