using Models.Category;

namespace DAL.CategoryRepository
{
    public interface ICategoryRepository
    {
        Task<IEnumerable<CategoryFull>> GetAll();
        Task<CategoryFull> GetById(byte id);
        Task<byte> Add(AddCategory category);
        Task<bool> Update(UpdateCategory category);
        Task<bool> Delete(byte id);
    }
}