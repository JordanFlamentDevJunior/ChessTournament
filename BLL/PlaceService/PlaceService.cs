using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL.PlaceRepository;
using Models.Place;
using DAL.PlaceRepository;
using APITournamentException;

namespace BLL.PlaceService
{
    public class PlaceService : IPlaceService
    {
        private readonly IPlaceRepository _repository;
        public PlaceService(IPlaceRepository repository)
        {
            _repository = repository;
        }
        public async Task<IEnumerable<PlaceFull>> GetAll()
        {
            if (_repository == null)
                throw new BusinessException("Place repository is not available.");

            return await _repository.GetAll();
        }
        public async Task<PlaceFull> GetById(int id)
        {
            if (_repository == null)
                throw new BusinessException("Place repository is not available.");

            return await _repository.GetById(id);
        }
        public async Task<int> Add(AddPlace place)
        {
            if (_repository == null)
                throw new BusinessException("Place repository is not available.");

            return await _repository.Add(place);
        }
        public async Task<bool> Update(UpdatePlace place)
        {
            if (_repository == null)
                throw new BusinessException("Place repository is not available.");

            return await _repository.Update(place);
        }
        public async Task<bool> Delete(int id)
        {
            if (_repository == null)
                throw new BusinessException("Place repository is not available.");

            return await _repository.Delete(id);
        }
    }
}
