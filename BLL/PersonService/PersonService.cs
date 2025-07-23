using DAL.PersonRepository;
using Models.Person;
using APITournamentException;

namespace BLL.PersonService
{
    public class PersonService : IPersonService
    {
        private readonly IPersonRepository _repository;
        public PersonService(IPersonRepository repository)
        {
            _repository = repository;
        }

        #region GetAll
        public async Task<IEnumerable<PersonFull>> GetAll()
        {
            if (_repository == null)
                throw new BusinessException("Person repository is not available.");
           
            return await _repository.GetAll();
        }
        #endregion

        #region GetById
        public Task<PersonFull> GetById(int id)
        {
            if (_repository == null)
                throw new BusinessException("Person repository is not available.");
            
            return _repository.GetById(id);
        }
        #endregion

        #region Add
        public async Task<int> Add(AddPerson person)
        {
            if (_repository == null)
                throw new BusinessException("Person repository is not available.");
            
            return await _repository.Add(person);
        }
        #endregion

        #region Update
        public async Task<bool> Update(UpdatePerson person)
        {
            if (_repository == null)
                throw new BusinessException("Person repository is not available.");
            
            return await _repository.Update(person);
        }
        #endregion

        #region Delete
        public async Task<bool> Delete(int id)
        {
            if (_repository == null)
                throw new BusinessException("Person repository is not available.");
            
            return await _repository.Delete(id);
        }
        #endregion
    }
}
