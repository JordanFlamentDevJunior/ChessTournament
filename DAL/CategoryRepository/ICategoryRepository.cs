using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Category;

namespace DAL.CategoryRepository
{
    public interface ICategoryRepository
    {
        Task<Guid> Add(AddCategory category);

        Task<IEnumerable<CategoryFull>> GetAll();

        Task<CategoryFull> GetById(Guid id);

        Task<bool> Update(UpdateCategory category);

        Task<bool> Delete(Guid id);
    }
}
