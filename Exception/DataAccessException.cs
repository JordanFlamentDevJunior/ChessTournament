using System;

namespace APITournamentException
{
    public class DataAccessException : Exception
    {
        public DataAccessException() : base(){ }
        public DataAccessException(string message) : base(message){ }
        public DataAccessException(string message, Exception innerException) : base(message, innerException){ }
        public DataAccessException(string message, string? errorCode) : base(message)
        {
            ErrorCode = errorCode;
        }
        public string? ErrorCode{ get; set; }
    }
}
