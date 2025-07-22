using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Status;

namespace BLL.StatusService
{
    public interface IStatusService
    {
        Task<IEnumerable<StatusFull>> GetAll();
        Task<StatusFull> GetById(int id);
        Task<int> Add(AddStatus status);
        Task<bool> Delete(int id);
    }
}