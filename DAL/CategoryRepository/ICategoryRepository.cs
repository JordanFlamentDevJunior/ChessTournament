using Models.Category;

namespace DAL.CategoryRepository
{
    public interface ICategoryRepository
    {
        Task<IEnumerable<CategoryFull>> GetAll();
        Task<CategoryFull> GetById(int id);
        Task<int> Add(AddCategory category);
        Task<bool> Update(UpdateCategory category);
        Task<bool> Delete(int id);
    }
}