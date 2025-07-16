using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.Category
{
    public class UpdateCategory
    {
        public int IdCategory { get; set; }
        public string NameCategory { get; set; }
        public int MinAge { get; set; }
        public int MaxAge { get; set; }
    }
}
