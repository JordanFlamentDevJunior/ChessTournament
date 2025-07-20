using Models.Gender;

namespace BLL.GenderService
{
    public interface IGenderService
    {
        Task<IEnumerable<GenderFull>> GetAll();
        Task<GenderFull> GetById(byte id);
        Task<byte> Add(AddGender gender);
        Task<bool> Delete(byte id);
    }
}