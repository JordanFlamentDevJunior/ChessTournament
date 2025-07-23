using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.Person
{
    public class AddPerson
    {
        public string Pseudo { get; set; }
        public int Gender { get; set; }
        public string Mail { get; set; }
        public string Password { get; set; }
        public DateOnly DateOfBirth { get; set; }
        public int Role { get; set; }
        public int Elo { get; set; }
    }
}
