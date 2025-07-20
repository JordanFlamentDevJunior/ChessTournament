using Models.Role;

namespace BLL.RoleService
{
    public interface IRoleService
    {
        Task<IEnumerable<RoleFull>> GetAll();
        Task<RoleFull> GetById(byte id);
        Task<byte> Add(AddRole role);
        Task<bool> Delete(byte id);
    }
}