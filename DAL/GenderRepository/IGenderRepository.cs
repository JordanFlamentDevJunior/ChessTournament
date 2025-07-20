using Models.Gender;

namespace DAL.GenderRepository
{
    public interface IGenderRepository
    {
        Task<IEnumerable<GenderFull>> GetAll();
        Task<GenderFull> GetById(byte id);
        Task<byte> Add(AddGender category);
        Task<bool> Delete(byte id);
    }
}