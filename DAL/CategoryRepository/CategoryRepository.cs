using APITournamentException;
using Azure;
using Microsoft.Data.SqlClient;
using Models.Category;
using System.Data;
using System.Data.Common;

namespace DAL.CategoryRepository
{
    public class CategoryRepository : RepositoryBase, ICategoryRepository
    {
        private readonly SqlConnection _connection;

        public CategoryRepository(SqlConnection connection) : base(connection)
        {
            _connection = connection;
        }

        #region GetAll
        public async Task<IEnumerable<CategoryFull>> GetAll()
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            List<CategoryFull> reponse = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Category", _connection);

            // reset de la connection
            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                CategoryFull category = new()
                {
                    IdCategory = reader.GetInt32(reader.GetOrdinal("Id_Category")),
                    NameCategory = reader.GetString(reader.GetOrdinal("Name_Category")).Trim().ToLower(),
                    MinAge = reader.GetInt32(reader.GetOrdinal("MinAge")),
                    MaxAge = reader.GetInt32(reader.GetOrdinal("MaxAge"))
                };
                reponse.Add(category);
            }

            // fermer la connexion quoi qu'il arrive
            await ConnectionResetAsync();
            return reponse.AsEnumerable();
        }
        #endregion

        #region GET BY ID
        public async Task<CategoryFull> GetById(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            CategoryFull reponse = new();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT * FROM Category WHERE Id_Category = @Id";
            cmd.Parameters.AddWithValue("@Id", id);

                // reset de la connection
            await ConnectionResetAsync();
            await _connection.OpenAsync();

            // Exécution de la commande
            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                // Lecture des résultats
                reponse = new CategoryFull()
                {
                    IdCategory = reader.GetInt32(reader.GetOrdinal("Id_Category")),
                    NameCategory = reader.GetString(reader.GetOrdinal("Name_Category")).Trim().ToLower(),
                    MinAge = reader.GetInt32(reader.GetOrdinal("MinAge")),
                    MaxAge = reader.GetInt32(reader.GetOrdinal("MaxAge"))
                };
            }

            await ConnectionResetAsync();
            return reponse;
        }
        #endregion

        #region Add
        public async Task<int> Add(AddCategory category)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            int newId = -1; // pur indiquer une erreur par défaut

            SqlCommand command = new SqlCommand("[dbo].[AddCategory]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            // Output parameter (new id)
            SqlParameter outputParameter = new SqlParameter("@Id_Category", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };
            command.Parameters.AddWithValue("@Name_Category", category.NameCategory.Trim().ToLower());
            command.Parameters.AddWithValue("@MinAge", category.MinAge);
            command.Parameters.AddWithValue("@MaxAge", category.MaxAge);
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

        #region UPDATE
        public async Task<bool> Update(UpdateCategory category)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            bool reponse = false;
            SqlCommand cmd = new SqlCommand("[dbo].[UpdateCategory]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Category", category.IdCategory);
            cmd.Parameters.AddWithValue("@MinAge", category.MinAge);
            cmd.Parameters.AddWithValue("@MaxAge", category.MaxAge);

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

        #region DELETE
        public async Task<bool> Delete(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            bool reponse = false;
            using SqlCommand cmd = new SqlCommand("[dbo].[DeleteCategory]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Category", id);

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