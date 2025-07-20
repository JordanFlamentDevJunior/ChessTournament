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

            try
            {
                IEnumerable<CategoryFull> categories = await _repository.GetAll();
                return categories;
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                throw new Exception("An error occurred while retrieving categories.", ex);
            }
        }
        #endregion

        #region GetById
        public Task<CategoryFull> GetById(byte id)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            try
            {
                return _repository.GetById(id);
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                throw new Exception($"An error occurred while retrieving the category with ID {id}.", ex);
            }
        }
        #endregion

        #region Add
        public async Task<byte> Add(AddCategory category)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            try
            {
                byte reponse = await _repository.Add(category);
                return reponse;
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                throw new Exception("An error occurred while adding the category.", ex);
            }
        }
        #endregion

        #region Update
        public async Task<bool> Update(UpdateCategory category)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            try
            {
                return await _repository.Update(category);
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                throw new Exception("An error occurred while updating the category.", ex);
            }
        }
        #endregion
       
        #region Delete
        public async Task<bool> Delete(byte id)
        {
            if (_repository == null)
                throw new BusinessException("Category repository is not available.");

            try
            {
                return await _repository.Delete(id);
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                throw new Exception($"An error occurred while deleting the category with ID {id}.", ex);
            }
        }
        #endregion
    }
}