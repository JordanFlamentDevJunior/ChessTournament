using DAL.StatusRepository;
using Models.Status;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.StatusService
{
    public class StatusService : IStatusService
    {
        private readonly IStatusRepository _repository;
        public StatusService(IStatusRepository repository)
        {
            _repository = repository;
        }

        #region GetAll
        public async Task<IEnumerable<StatusFull>> GetAll()
        {
            IEnumerable<StatusFull> status = await _repository.GetAll();
            return status;
        }
        #endregion

        #region GetById
        public Task<StatusFull> GetById(byte id)
        {
            return _repository.GetById(id);
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddStatus status)
        {
            byte reponse = await _repository.Add(status);
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
