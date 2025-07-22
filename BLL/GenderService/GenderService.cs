using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL.Gender;
using APITournamentException;
using Models.Gender;

namespace BLL.GenderService
{
    public class GenderService : IGenderService
    {
        private readonly IGenderRepository _repository;
        public GenderService(IGenderRepository repository)
        {
            _repository = repository;
        }

        #region GetAll
        public async Task<IEnumerable<GenderFull>> GetAll()
        {
            if (_repository == null)
                throw new BusinessException("Gender repository is not available.");

            return await _repository.GetAll();
        }
        #endregion

        #region GetById
        public Task<GenderFull> GetById(int id)
        {
            if (_repository == null)
                throw new BusinessException("Gender repository is not available.");

            return _repository.GetById(id);
        }
        #endregion

        #region Add
        public async Task<int> Add(AddGender gender)
        {
            if (_repository == null)
                throw new BusinessException("Gender repository is not available.");

            return await _repository.Add(gender);
        }
        #endregion

        #region Delete
        public Task<bool> Delete(int id)
        {
            if (_repository == null)
                throw new BusinessException("Gender repository is not available.");

            return _repository.Delete(id);
        }
        #endregion
    }
}
