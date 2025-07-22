using Models.Category;

namespace BLL.CategoryService
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryFull>> GetAll();
        Task<CategoryFull> GetById(int id);
        Task<int> Add(AddCategory category);
        Task<bool> Update(UpdateCategory category);
        Task<bool> Delete(int id);
    }
}