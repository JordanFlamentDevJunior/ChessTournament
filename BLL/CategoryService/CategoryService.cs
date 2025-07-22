using DAL.CategoryRepository;
using Models.Category;
using APITournamentException;

namespace BLL.CategoryService
{
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _repository;

        public CategoryService(ICategoryRepository repository)
        {
            _repository = repository;
        }

        #region GetAll
        public async Task<IEnumerable<CategoryFull>> GetAll()
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            return await _repository.GetAll();
        }
        #endregion

        #region GetById
        public Task<CategoryFull> GetById(int id)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            return _repository.GetById(id);
        }
        #endregion

        #region Add
        public async Task<int> Add(AddCategory category)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            return await _repository.Add(category);

        }
        #endregion

        #region Update
        public async Task<bool> Update(UpdateCategory category)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            return await _repository.Update(category);
        }
        #endregion
       
        #region Delete
        public async Task<bool> Delete(int id)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            return await _repository.Delete(id);
        }
        #endregion
    }
}