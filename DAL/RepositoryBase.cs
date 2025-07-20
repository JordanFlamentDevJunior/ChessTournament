using Microsoft.Data.SqlClient;
using System.Data;

namespace DAL
{
    public abstract class RepositoryBase
    {
        protected readonly SqlConnection _connection;

        protected RepositoryBase(SqlConnection connection)
        {
            _connection = connection;
        }

        protected async Task ConnectionResetAsync()
        {
            if (_connection?.State != ConnectionState.Closed)
            {
                await _connection.CloseAsync();
            }
        }
    }
}