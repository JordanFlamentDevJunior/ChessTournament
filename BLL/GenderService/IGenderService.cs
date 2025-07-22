using Models.Gender;

namespace BLL.GenderService
{
    public interface IGenderService
    {
        Task<IEnumerable<GenderFull>> GetAll();
        Task<GenderFull> GetById(int id);
        Task<int> Add(AddGender category);
        Task<bool> Delete(int id);
    }
}