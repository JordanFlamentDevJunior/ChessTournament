using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Role;

namespace BLL.RoleService
{
    public interface IRoleService
    {
        Task<IEnumerable<RoleFull>> GetAll();
        Task<RoleFull> GetById(int id);
        Task<int> Add(AddRole role);
        Task<bool> Delete(int id);
    }
}