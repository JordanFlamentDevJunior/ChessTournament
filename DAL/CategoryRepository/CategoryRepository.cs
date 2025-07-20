using Azure;
using Microsoft.Data.SqlClient;
using Models.Category;
using System.Data;
using APITournamentException;

namespace DAL.CategoryRepository
{
    public class CategoryRepository : RepositoryBase, ICategoryRepository
    {
        // a Faire :
        // verifier qu'une nouvelle tranche se trouve a sa bonne place ?

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
            SqlCommand cmd = new SqlCommand("SELECT Id_Category, Name_Category, MinAge, MaxAge FROM Category", _connection);

            try
            {
                // reset de la connection
                await ConnectionResetAsync();
                await _connection.OpenAsync();

                await using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        CategoryFull category = new()
                        {
                            IdCategory = reader.GetByte(reader.GetOrdinal("Id_Category")),
                            NameCategory = reader.GetString(reader.GetOrdinal("Name_Category")).Trim().ToLower(),
                            MinAge = reader.GetByte(reader.GetOrdinal("MinAge")),
                            MaxAge = reader.GetByte(reader.GetOrdinal("MaxAge"))
                        };
                        reponse.Add(category);

                        return reponse.AsEnumerable();
                    }
                    throw new DataAccessException("No categories found in the database.");
                }
            }
            catch (SqlException ex)
            {
                throw new DataAccessException($"GetAll SQL Error: {ex.Message}");
            }
            finally
            {
                // fermer la connexion quoi qu'il arrive
                await ConnectionResetAsync();
            }

        }
        #endregion

        #region GET BY ID
        public async Task<CategoryFull> GetById(byte id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT Id_Category,Name_Category,MinAge,MaxAge FROM Category WHERE Id_Category = @Id";
            cmd.Parameters.AddWithValue("@Id", id);

            try
            {
                // reset de la connection
                await ConnectionResetAsync();
                await _connection.OpenAsync();

                // Exécution de la commande
                await using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        // Lecture des résultats
                        CategoryFull reponse = new CategoryFull()
                        {
                            IdCategory = reader.GetByte(reader.GetOrdinal("Id_Category")),
                            NameCategory = reader.GetString(reader.GetOrdinal("Name_Category")).Trim().ToLower(),
                            MinAge = reader.GetByte(reader.GetOrdinal("MinAge")),
                            MaxAge = reader.GetByte(reader.GetOrdinal("MaxAge"))
                        };
                        return reponse;
                    }
                // Si aucune ligne n'est retournée, on lance une exception
                throw new DataAccessException($"No category found with ID {id}.");
                }
            }
            catch (SqlException ex)
            {
                throw new DataAccessException($"GetById SQL Error: {ex.Message}");
            }
            finally
            {
                await ConnectionResetAsync();
            }
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddCategory category)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            byte newId = 255; // pur indiquer une erreur par défaut

            SqlCommand command = new SqlCommand("[dbo].[AddCategory]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@Name_Category", category.NameCategory.Trim().ToLower());
            command.Parameters.AddWithValue("@MinAge", category.MinAge);
            command.Parameters.AddWithValue("@MaxAge", category.MaxAge);

            try
            {
                // reset de la connection
                await ConnectionResetAsync();
                await _connection.OpenAsync();

                // Exécution de la commande
                await using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync() && !reader.IsDBNull(0))
                    {
                        // Lecture des résultats
                        newId = reader.GetByte(reader.GetOrdinal("Id_Category"));
                        string?  errorMessage = reader.IsDBNull(reader.GetOrdinal("ErrorMessage")) 
                            ? null: reader.GetString(reader.GetOrdinal("ErrorMessage"));

                        // Si l'ID est 255 ou s'il y a un message d'erreur, on lance une exception
                        if (errorMessage != null || newId == 255)
                            throw new DataAccessException($"Error adding category: {errorMessage}");

                        // Si tout est bon, on retourne le nouvel ID
                        return newId;
                    }
                    // Si aucune ligne n'est retournée, on lance une exception
                    throw new DataAccessException("No data returned from the stored procedure.");
                }
            }
            // recuperer les exceptions SQL
            catch (SqlException ex)
            {
                throw new DataAccessException($"AddCategory SQL Error: {ex.Message}");
            }
            finally
            {
                // fermer la connexion quoi qu'il arrive
                await ConnectionResetAsync();
            }
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
            cmd.Parameters.AddWithValue("@Name_Category", category.NameCategory.Trim().ToLower());
            cmd.Parameters.AddWithValue("@MinAge", category.MinAge);
            cmd.Parameters.AddWithValue("@MaxAge", category.MaxAge);

            try
            {
                // reset de la connection
                await ConnectionResetAsync();
                await _connection.OpenAsync();

                // Exécution de la commande
                using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                { 
                    if(await reader.ReadAsync())
                    {
                        // Lecture des résultats
                        bool success = reader.GetBoolean(reader.GetOrdinal("Result"));
                        string error = reader.GetString(reader.GetOrdinal("ErrorMessage"));

                        // Si l'update a échoué, on lance une exception
                        if (error != null || !success)
                            throw new Exception($"Error updating category: {error}");

                        // Si l'update a réussi, on met reponse à true
                        reponse = true;
                        return reponse;
                    }
                    throw new DataAccessException("No data returned from the stored update procedure.");
                }
            }
            catch (Exception ex)
            {
                throw new DataAccessException($"UpdateCategory SQL Error: {ex.Message}");
            }
            finally
            {
                // fermer la connexion quoi qu'il arrive
                await ConnectionResetAsync();
            }
        }
        #endregion

        #region DELETE
        public async Task<bool> Delete(byte id)
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

            try
            {
                // reset de la connection
                await ConnectionResetAsync();
                await _connection.OpenAsync();

                // Exécution de la commande
                using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        // Lecture des résultats
                        bool succes = reader.GetBoolean(reader.GetOrdinal("Result"));
                        string error = reader.GetString(reader.GetOrdinal("ErrorMessage"));

                        // Si la suppression a échoué, on lance une exception
                        if (error != null || !succes)
                            throw new Exception($"Error deleting category: {error}");

                        // Si la suppression a réussi, on met reponse à true
                        reponse = true;
                        return reponse;
                    }
                    // Si aucune ligne n'est retournée, on lance une exception
                    throw new DataAccessException("No data returned from the stored delete procedure.");
                }
            }
            catch (Exception ex)
            {
                throw new DataAccessException($"DeleteCategory SQL Error: {ex.Message}");
            }
            finally
            {
                await ConnectionResetAsync();

            }
        }
        #endregion
    }
}