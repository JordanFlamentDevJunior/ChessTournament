using Models.Role;

namespace DAL.RoleRepository
{
    public interface IRoleRepository
    {
        Task<IEnumerable<RoleFull>> GetAll();
        Task<RoleFull> GetById(byte id);
        Task<byte> Add(AddRole role);
        Task<bool> Delete(byte id);
    }
}