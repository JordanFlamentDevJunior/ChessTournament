using Models.Status;

namespace DAL.StatusRepository
{
    public interface IStatusRepository
    {
        Task<IEnumerable<StatusFull>> GetAll();
        Task<StatusFull> GetById(int id);
        Task<int> Add(AddStatus status);
        Task<bool> Delete(int id);
    }
}
