using Models.Role;

namespace DAL.RoleRepository
{
    public interface IRoleRepository
    {
        Task<IEnumerable<RoleFull>> GetAll();
        Task<RoleFull> GetById(int id);
        Task<int> Add(AddRole role);
        Task<bool> Delete(int id);
    }
}
