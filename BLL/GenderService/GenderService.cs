using DAL.GenderRepository;
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
            IEnumerable<GenderFull> genders = await _repository.GetAll();
            return genders;
        }
        #endregion

        #region GetById
        public Task<GenderFull> GetById(byte id)
        {
            return _repository.GetById(id);
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddGender gender)
        {
            byte reponse = await _repository.Add(gender);
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