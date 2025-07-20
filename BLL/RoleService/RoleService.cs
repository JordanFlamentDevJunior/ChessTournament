using DAL.RoleRepository;
using Models.Role;

namespace BLL.RoleService
{
    public class RoleService : IRoleService
    {
        private readonly IRoleRepository _repository;
        public RoleService(IRoleRepository repository)
        {
            _repository = repository;
        }

        #region GetAll
        public async Task<IEnumerable<RoleFull>> GetAll()
        {
            IEnumerable<RoleFull> roles = await _repository.GetAll();
            return roles;
        }
        #endregion

        #region GetById
        public Task<RoleFull> GetById(byte id)
        {
            return _repository.GetById(id);
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddRole role)
        {
            byte reponse = await _repository.Add(role);
            return reponse;
        }
        #endregion

        #region Delete
        public async Task<bool> Delete(byte id)
        {
            return await _repository.Delete(id);
        }
        #endregion
    }
}