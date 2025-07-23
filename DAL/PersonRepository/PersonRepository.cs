using APITournamentException;
using Microsoft.Data.SqlClient;
using Models.Person;
using System.Data;

namespace DAL.PersonRepository
{
    public class PersonRepository : RepositoryBase, IPersonRepository
    {
        private readonly SqlConnection _connection;
        public PersonRepository(SqlConnection connection) : base(connection)
        {
            _connection = connection;
        }


        #region GetAll
        public async Task<IEnumerable<PersonFull>> GetAll()
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            List<PersonFull> response = new();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Person", _connection);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                PersonFull person = new()
                {
                    IdPerson = reader.GetInt32(reader.GetOrdinal("Id_Person")),
                    Pseudo = reader.GetString(reader.GetOrdinal("Pseudo")).Trim().ToLower(),
                    Gender = reader.GetInt32(reader.GetOrdinal("Gender")),
                    Mail = reader.GetString(reader.GetOrdinal("Mail")).Trim().ToLower(),
                    DateOfBirth = DateOnly.FromDateTime(reader.GetDateTime(reader.GetOrdinal("BirthDate"))),
                    DateRegist = DateOnly.FromDateTime(reader.GetDateTime(reader.GetOrdinal("DateRegist"))),
                    Role = reader.GetInt32(reader.GetOrdinal("Role")),
                    Elo = reader.GetInt32(reader.GetOrdinal("Elo")),
                    NbrPartPlayed = reader.GetInt32(reader.GetOrdinal("NbrPartPlayed")),
                    NbrPartWin = reader.GetInt32(reader.GetOrdinal("NbrPartWin")),
                    NbrPartLost = reader.GetInt32(reader.GetOrdinal("NbrPartLost")),
                    NbrPartDraw = reader.GetInt32(reader.GetOrdinal("NbrPartDraw")),
                    Score = reader.GetInt32(reader.GetOrdinal("Score"))
                };
                response.Add(person);
            }
            await ConnectionResetAsync();
            return response.AsEnumerable();
        }
        #endregion

        #region GetById
        public async Task<PersonFull> GetById(int id)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            PersonFull response = new();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = "SELECT * FROM Person WHERE Id_Person = @id";
            cmd.Parameters.Add(new SqlParameter("@id", id));

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            SqlDataReader reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                response = new PersonFull()
                {
                    IdPerson = reader.GetInt32(reader.GetOrdinal("Id_Person")),
                    Pseudo = reader.GetString(reader.GetOrdinal("Pseudo")).Trim().ToLower(),
                    Gender = reader.GetInt32(reader.GetOrdinal("Gender")),
                    Mail = reader.GetString(reader.GetOrdinal("Mail")).Trim().ToLower(),
                    DateOfBirth = DateOnly.FromDateTime(reader.GetDateTime(reader.GetOrdinal("BirthDate"))),
                    DateRegist = DateOnly.FromDateTime(reader.GetDateTime(reader.GetOrdinal("DateRegist"))),
                    Role = reader.GetInt32(reader.GetOrdinal("Role")),
                    Elo = reader.GetInt32(reader.GetOrdinal("Elo")),
                    NbrPartPlayed = reader.GetInt32(reader.GetOrdinal("NbrPartPlayed")),
                    NbrPartWin = reader.GetInt32(reader.GetOrdinal("NbrPartWin")),
                    NbrPartLost = reader.GetInt32(reader.GetOrdinal("NbrPartLost")),
                    NbrPartDraw = reader.GetInt32(reader.GetOrdinal("NbrPartDraw")),
                    Score = reader.GetInt32(reader.GetOrdinal("Score"))
                };
            }

            await ConnectionResetAsync();
            return response;
        }
        #endregion

        #region Add
        public async Task<int> Add(AddPerson person)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            int newId = -1;

            SqlCommand cmd = new SqlCommand("[dbo].[AddPerson]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            SqlParameter outputParam = new SqlParameter("@Id_Person", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };
            cmd.Parameters.AddWithValue("@Pseudo", person.Pseudo.Trim().ToLower());
            cmd.Parameters.AddWithValue("@Gender", person.Gender);
            cmd.Parameters.AddWithValue("@Email", person.Mail.Trim().ToLower());
            cmd.Parameters.AddWithValue("@Password", person.Password.Trim());
            cmd.Parameters.AddWithValue("@BirthDate", person.DateOfBirth);
            cmd.Parameters.AddWithValue("@Role", person.Role);
            cmd.Parameters.AddWithValue("@Elo", person.Elo);
            cmd.Parameters.Add(outputParam);

            await ConnectionResetAsync();
            await _connection.OpenAsync();

            cmd.ExecuteNonQuery();
            newId = (int)outputParam.Value;

            await ConnectionResetAsync();
            return newId;
        }
        #endregion

        #region Update
        public async Task<bool> Update(UpdatePerson person)
        {
            if (_connection == null)
                throw new DataAccessException("Database connection is not available.");

            // Initialisation  des variables
            bool reponse = false;
            SqlCommand cmd = new SqlCommand("[dbo].[UpdatePerson]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Person", person.IdPerson);
            cmd.Parameters.AddWithValue("@Elo", person.Elo);
            cmd.Parameters.AddWithValue("@NbrPartPlayed", person.NbrPartPlayed);
            cmd.Parameters.AddWithValue("@NbrPartWin", person.NbrPartWin);
            cmd.Parameters.AddWithValue("@NbrPartLost", person.NbrPartLost);
            cmd.Parameters.AddWithValue("@NbrPartDraw", person.NbrPartDraw);
            cmd.Parameters.AddWithValue("@Score", person.Score);

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
            using SqlCommand cmd = new SqlCommand("[dbo].[DeletePerson]", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Id_Person", id);

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
