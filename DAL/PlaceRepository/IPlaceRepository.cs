using Models.Place;

namespace DAL.PlaceRepository
{
    public interface IPlaceRepository
    {
        Task<IEnumerable<PlaceFull>> GetAll();
        Task<PlaceFull> GetById(int id);
        Task<int> Add(AddPlace place);
        Task<bool> Update(UpdatePlace place);
        Task<bool> Delete(int id);
    }
}