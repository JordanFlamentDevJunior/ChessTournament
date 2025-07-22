using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using APITournamentException;
using Microsoft.Data.SqlClient;
using Models.Place;
using System.Data;

namespace DAL.PlaceRepository
{
    public class PlaceRepository : RepositoryBase, IPlaceRepository
    {
        private readonly SqlConnection _connection;
        public PlaceRepository(SqlConnection connection) : base(connection)
        {
            _connection = connection;
        }

        #region GetAll
        public async Task<IEnumerable<PlaceFull>> GetAll()
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            List<PlaceFull> response = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Place", _connection);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            { 
                PlaceFull place = new()
                {
                    IdPlace = reader.GetInt32(reader.GetOrdinal("Id_Place")),
                    NamePlace = reader.GetString(reader.GetOrdinal("Name_Place")).Trim().ToLower(),
                    Address = reader.GetString(reader.GetOrdinal("Address")).Trim().ToLower()
                };
                response.Add(place);
            }
            await ConnectionResetAsync();
            return response.AsEnumerable();
        }
        #endregion

        #region GetById
        public async Task<PlaceFull> GetById(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            PlaceFull response = new();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT * FROM Place WHERE Id_Place = @Id";
            cmd.Parameters.AddWithValue("@Id", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                response = new PlaceFull()
                {
                    IdPlace = reader.GetInt32(reader.GetOrdinal("Id_Place")),
                    NamePlace = reader.GetString(reader.GetOrdinal("Name_Place")).Trim().ToLower(),
                    Address = reader.GetString(reader.GetOrdinal("Address")).Trim().ToLower()
                };
            }
            
            await ConnectionResetAsync();
            return response;
        }
        #endregion

        #region Add
        public async Task<int> Add(AddPlace place)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            int newId = -1;

            SqlCommand cmd = new SqlCommand("[dbo].[AddPlace]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            SqlParameter outputParameter = new SqlParameter("@Id_Place", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };
            cmd.Parameters.AddWithValue("@Name_Place", place.Name.Trim().ToLower());
            cmd.Parameters.AddWithValue("@Address", place.Address.Trim().ToLower());
            cmd.Parameters.Add(outputParameter);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            cmd.ExecuteNonQuery();
            newId = (int)outputParameter.Value;

            await ConnectionResetAsync();
            return newId;
        }
        #endregion

        #region Update
        public async Task<bool> Update(UpdatePlace place)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            bool isUpdated = false;

            SqlCommand cmd = new SqlCommand("[dbo].[UpdatePlace]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Place", place.IdPlace);
            cmd.Parameters.AddWithValue("@Name_Place", place.Name.Trim().ToLower());
            cmd.Parameters.AddWithValue("@Address", place.Address.Trim().ToLower());

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            int rowsAffected = await cmd.ExecuteNonQueryAsync();

            if (rowsAffected == 1)
            {
                isUpdated = true;
            }

            await ConnectionResetAsync();
            return isUpdated;
        }
        #endregion

        #region Delete
        public async Task<bool> Delete(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            bool isDeleted = false;
            SqlCommand cmd = new SqlCommand("[dbo].[DeletePlace]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Place", id);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            int rowsAffected = await cmd.ExecuteNonQueryAsync();
            if (rowsAffected == 1)
            {
                isDeleted = true;
            }

            await ConnectionResetAsync();
            return isDeleted;
        }
        #endregion
    }
}
