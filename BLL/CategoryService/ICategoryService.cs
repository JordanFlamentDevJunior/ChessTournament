using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Category;

namespace BLL.CategoryService
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryFull>> GetAll();

        Task<Guid> Add(AddCategory category);

        Task<bool> Update(UpdateCategory category);

        Task<CategoryFull> GetById(Guid id);

        Task<bool> Delete(Guid id);
    }
}
