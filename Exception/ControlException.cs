using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace APITournamentException
{
    public class ControlException : Exception
    {
        public ControlException() : base() { }
        public ControlException(string message) : base(message) { }
        public ControlException(string message, Exception innerException) : base(message, innerException) { }
        public ControlException(string message, string? errorCode) : base(message)
        {
            ErrorCode = errorCode;
        }
        public string? ErrorCode { get; set; }
    }
}
