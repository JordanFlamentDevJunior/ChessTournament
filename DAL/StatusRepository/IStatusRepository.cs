using Models.Status;

namespace DAL.StatusRepository
{
    public interface IStatusRepository
    {
        Task<IEnumerable<StatusFull>> GetAll();
        Task<StatusFull> GetById(byte id);
        Task<byte> Add(AddStatus status);
        Task<bool> Delete(byte id);
    }
}