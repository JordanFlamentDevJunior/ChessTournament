using Azure;
using Microsoft.Data.SqlClient;
using Models.Category;
using System.Data;

namespace DAL.CategoryRepository
{
    public class CategoryRepository : ICategoryRepository
    {
        private readonly SqlConnection _connection;

        public CategoryRepository(SqlConnection connection)
        {
            _connection = connection;
        }

        #region Add
        public async Task<Guid> Add(AddCategory category)
        {
            SqlCommand command = new SqlCommand("SP_AddCategory", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@NameCategory", category.NameCategory);
            command.Parameters.AddWithValue("@MinAge", category.MinAge);
            command.Parameters.AddWithValue("@MaxAge", category.MaxAge);

            Guid newId = Guid.NewGuid();

            await _connection.OpenAsync();
            
            await using (SqlDataReader reader = await command.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync() && reader[0] != DBNull.Value)
                {
                    newId = reader.GetGuid(reader.GetOrdinal("Id_Category"));
                }
            }
            await _connection.CloseAsync();
            return newId;
        }
        #endregion

        #region GetAll
        /// <summary>
        /// Retourner toutes les catégories
        /// </summary>
        public async Task<IEnumerable<CategoryFull>> GetAll()
        {
            List<CategoryFull> reponse = new ();

            await _connection.OpenAsync();

            SqlCommand cmd = new SqlCommand("SELECT Id_Category, NameCategory, MinAge, MaxAge FROM Categories", _connection);

            SqlDataReader reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                CategoryFull category = new()
                {
                    Id = reader.GetGuid(reader.GetOrdinal("Id_Category")),
                    NameCategory = reader.GetString(reader.GetOrdinal("NameCategory")),
                    MinAge = reader.GetInt32(reader.GetOrdinal("MinAge")),
                    MaxAge = reader.GetInt32(reader.GetOrdinal("MaxAge"))
                };
                reponse.Add(category);
                await _connection.CloseAsync();
            }
            return reponse.AsEnumerable();
        }
        #endregion

        #region GET BY ID
        /// <summary>
        /// retourner une catégorie par son ID
        /// </summary>
        public async Task<CategoryFull> GetById(Guid id)
        {
            CategoryFull reponse = new();

            SqlCommand cmd = _connection.CreateCommand();

            cmd.CommandText = "SELECT Id_Category,NameCategory,MinAge,MaxAge FROM Category WHERE IdCategory = @Id";

            cmd.Parameters.AddWithValue("@Id", id);

            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                reponse = new CategoryFull()
                {
                    Id = reader.GetGuid(reader.GetOrdinal("Id_Category")),
                    NameCategory = reader.GetString(reader.GetOrdinal("NameCategory")),
                    MinAge = reader.GetInt32(reader.GetOrdinal("MinAge")),
                    MaxAge = reader.GetInt32(reader.GetOrdinal("MaxAge"))
                };
            }
            await _connection.CloseAsync();
            return reponse;
        }
        #endregion

        #region UPDATE
        public async Task<bool> Update(UpdateCategory category)
        {
            bool reponse = false;
            SqlCommand cmd = new SqlCommand("SP_UpdateCategory", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.AddWithValue("@Id_Category", category.IdCategory);
            cmd.Parameters.AddWithValue("@NameCategory", category.NameCategory);
            cmd.Parameters.AddWithValue("@MinAge", category.MinAge);
            cmd.Parameters.AddWithValue("@MaxAge", category.MaxAge);

            await _connection.OpenAsync();

            int rowsAffected = await cmd.ExecuteNonQueryAsync();

            if (rowsAffected == 1)
            {
                reponse = true;
            }

            await _connection.CloseAsync();

            return reponse;

        }
        #endregion

        #region DELETE
        public async Task<bool> Delete(Guid id)
        {
            bool response = false;

            using SqlCommand command = new SqlCommand("SP_DeleteCategory", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            command.Parameters.AddWithValue("@Id_Category", id);

            await _connection.OpenAsync();

            int rowsAffected = await command.ExecuteNonQueryAsync();

            if (rowsAffected == 1)
            {
                response = true;
            }
            await _connection.CloseAsync();

            return response;
        }
        #endregion
    }
}