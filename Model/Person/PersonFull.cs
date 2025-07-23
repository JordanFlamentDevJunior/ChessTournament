using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.Person
{
    public class PersonFull
    {
        public int IdPerson { get; set; }
        public string Pseudo { get; set; }
        public int Gender { get; set; }
        public string Mail { get; set; }
        public DateOnly DateOfBirth { get; set; }
        public DateOnly DateRegist { get; set; }
        public int Role { get; set; }
        public int Elo { get; set; }
        public int NbrPartPlayed { get; set; }
        public int NbrPartWin { get; set; }
        public int NbrPartLost { get; set; }
        public int NbrPartDraw { get; set; }
        public int Score { get; set; }
    }
}
