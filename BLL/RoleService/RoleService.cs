using APITournamentException;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Role;
using DAL.RoleRepository;

namespace BLL.RoleService
{
    public class RoleService : IRoleService
    {
        private readonly IRoleRepository _repository;
        public RoleService(IRoleRepository repository)
        {
            _repository = repository;
        }
        public async Task<IEnumerable<RoleFull>> GetAll()
        {
            if (_repository == null)
                throw new BusinessException("Role repository is not available.");

            return await _repository.GetAll();
        }
        public async Task<RoleFull> GetById(int id)
        {
            if (_repository == null)
                throw new BusinessException("Role repository is not available.");

            return await _repository.GetById(id);
        }
        public async Task<int> Add(AddRole role)
        {
            if (_repository == null)
                throw new BusinessException("Role repository is not available.");

            return await _repository.Add(role);
        }
        public async Task<bool> Delete(int id)
        {
            if (_repository == null)
                throw new BusinessException("Role repository is not available.");

            return await _repository.Delete(id);
        }
    }
}
