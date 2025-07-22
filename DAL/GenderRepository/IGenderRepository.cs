using Models.Gender;

namespace DAL.GenderRepository
{
    public interface IGenderRepository
    {
        Task<IEnumerable<GenderFull>> GetAll();
        Task<GenderFull> GetById(int id);
        Task<int> Add(AddGender category);
        Task<bool> Delete(int id);
    }
}
