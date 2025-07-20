using Models.Status;

namespace BLL.StatusService
{
    public interface IStatusService
    {
        Task<IEnumerable<StatusFull>> GetAll();
        Task<StatusFull> GetById(byte id);
        Task<byte> Add(AddStatus status);
        Task<bool> Delete(byte id);
    }
}