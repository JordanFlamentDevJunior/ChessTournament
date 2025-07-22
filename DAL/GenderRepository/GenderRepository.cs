using APITournamentException;
using Microsoft.Data.SqlClient;
using Models.Category;
using Models.Gender;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            List<GenderFull> reponse = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Gender", _connection);

            // reset de la connection
            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                GenderFull gender = new()
                {
                    IdGender = reader.GetInt32(reader.GetOrdinal("Id_Gender")),
                    NameGender = reader.GetString(reader.GetOrdinal("ValueGender")).Trim().ToLower(),
                };
                reponse.Add(gender);
            }

            // fermer la connexion quoi qu'il arrive
            await ConnectionResetAsync();
            return reponse.AsEnumerable();
        }
        #endregion

        #region GET BY ID
        public async Task<GenderFull> GetById(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            GenderFull reponse = new();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT * FROM Gender WHERE Id_Gender = @Id";
            cmd.Parameters.AddWithValue("@Id", id);

            // reset de la connection
            await ConnectionResetAsync();
            await _connection.OpenAsync();

            // Exécution de la commande
            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                // Lecture des résultats
                reponse = new GenderFull()
                {
                    IdGender = reader.GetInt32(reader.GetOrdinal("Id_Gender")),
                    NameGender = reader.GetString(reader.GetOrdinal("ValueGender")).Trim().ToLower(),
                };
            }

            await ConnectionResetAsync();
            return reponse;
        }
        #endregion

        #region Add
        public async Task<int> Add(AddGender gender)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            int newId = -1; // pur indiquer une erreur par défaut

            SqlCommand command = new SqlCommand("[dbo].[AddGender]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            // Output parameter (new id)
            SqlParameter outputParameter = new SqlParameter("@Id_Gender", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };
            command.Parameters.AddWithValue("@Name_Gender", gender.NameGender.Trim().ToLower());
            command.Parameters.Add(outputParameter);

            // reset de la connection
            await ConnectionResetAsync();
            await _connection.OpenAsync();

            // Execute
            command.ExecuteNonQuery();
            newId = (int)outputParameter.Value;

            // fermer la connexion quoi qu'il arrive
            await ConnectionResetAsync();
            return newId;
        }
        #endregion

        #region DELETE
        public async Task<bool> Delete(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            bool reponse = false;
            using SqlCommand cmd = new SqlCommand("[dbo].[DeleteGender]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Gender", id);

            // reset de la connection
            await ConnectionResetAsync();
            await _connection.OpenAsync();

            int rowsAffected = await cmd.ExecuteNonQueryAsync();

            if (rowsAffected == 1)
                reponse = true;

            await ConnectionResetAsync();
            return reponse;
        }
        #endregion
    }
}
