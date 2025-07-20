using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace APITournamentException
{
    public class BusinessException : Exception
    {
        public BusinessException() : base() { }
        public BusinessException(string message) : base(message) { }
        public BusinessException(string message, Exception innerException) : base(message, innerException) { }
        public BusinessException(string message, string? errorCode) : base(message)
        {
            ErrorCode = errorCode;
        }
        public string? ErrorCode { get; set; }
    }
}
