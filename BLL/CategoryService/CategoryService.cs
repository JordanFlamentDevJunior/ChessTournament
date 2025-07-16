using DAL.CategoryRepository
using Models.Category;

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
                IEnumerable<CategoryFull> categories = await _repository.GetAll();
                return categories;
        }
        #endregion

        #region GetById
            public Task<CategoryFull> GetById(Guid id)
            {
                return _repository.GetById(id);
        }
        #endregion

        #region Add
            public async Task<Guid> Add(AddCategory category)
            {
                Guid reponse = await _repository.Add(category);
                return reponse;
        }
        #endregion

        #region Update
            public async Task<bool> Update(UpdateCategory category)
            {
                return await _repository.Update(category);
        }
        #endregion
       
        #region Delete
            public async Task<bool> Delete(Guid id)
            {
                return await _repository.Delete(id);
        }
        #endregion
    }
}
