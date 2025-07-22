using APITournamentException;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Status;
using DAL.StatusRepository;

namespace BLL.StatusService
{
    public class StatusService : IStatusService
    {
        private readonly IStatusRepository _repository;

        public StatusService(IStatusRepository repository)
        {
            _repository = repository;
        }
        public async Task<IEnumerable<StatusFull>> GetAll()
        {
            if (_repository == null)
                throw new BusinessException("Status repository is not available.");

            return await _repository.GetAll();
        }
        public async Task<StatusFull> GetById(int id)
        {
            if (_repository == null)
                throw new BusinessException("Status repository is not available.");

            return await _repository.GetById(id);
        }
        public async Task<int> Add(AddStatus status)
        {
            if (_repository == null)
                throw new BusinessException("Status repository is not available.");

            return await _repository.Add(status);
        }
        public async Task<bool> Delete(int id)
        {
            if (_repository == null)
                throw new BusinessException("Status repository is not available.");

            return await _repository.Delete(id);
        }
    }
}
