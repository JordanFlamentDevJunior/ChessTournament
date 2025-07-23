using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.Person
{
    public class UpdatePerson
    {
        public int IdPerson { get; set; }
        public int Elo { get; set; }
        public int NbrPartPlayed { get; set; }
        public int NbrPartWin { get; set; }
        public int NbrPartLost { get; set; }
        public int NbrPartDraw { get; set; }
        public int Score { get; set; }
    }
}
