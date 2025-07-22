using Models.Gender;

namespace DAL.Gender
{
    public interface IGenderRepository
    {
        Task<IEnumerable<GenderFull>> GetAll();
        Task<GenderFull> GetById(int id);
        Task<int> Add(AddGender category);
        Task<bool> Delete(int id);
    }
}
