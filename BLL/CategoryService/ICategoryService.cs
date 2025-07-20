using Models.Category;

namespace BLL.CategoryService
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryFull>> GetAll();
        Task<CategoryFull> GetById(byte id);
        Task<byte> Add(AddCategory category);
        Task<bool> Update(UpdateCategory category);
        Task<bool> Delete(byte id);
    }
}