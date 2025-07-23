using Models.Person;

namespace BLL.PersonService
{
    public interface IPersonService
    {
        Task<IEnumerable<PersonFull>> GetAll();
        Task<PersonFull> GetById(int id);
        Task<int> Add(AddPerson person);
        Task<bool> Update(UpdatePerson person);
        Task<bool> Delete(int id);
    }
}
