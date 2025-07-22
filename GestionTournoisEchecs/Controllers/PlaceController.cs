using Microsoft.AspNetCore.Mvc;
using BLL.PlaceService;
using Models.Place;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlaceController : ControllerBase
    {
        private readonly IPlaceService _service;

        public PlaceController(IPlaceService service)
        {
            _service = service;
        }

        #region GetAll
        // GET: api/<PlaceController>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                IEnumerable<PlaceFull> places = await _service.GetAll();
                if (places == null)
                    return NotFound("No places found.");

                return Ok(new { obj = places });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region GetById
        // GET api/<PlaceController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                PlaceFull place = await _service.GetById(id);

                if (place == null)
                    return NotFound($"Place with ID {id} not found.");

                return Ok(new { obj = place });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region Add
        // POST api/<PlaceController>
        [HttpPost]
        public async Task<IActionResult> Add(AddPlace place)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                int id = await _service.Add(new AddPlace
                {
                    Name = place.Name.Trim().ToLower(),
                    Address = place.Address.Trim().ToLower()
                });

                if(id == -1)
                    return BadRequest("Failed to add the place.");

                return Ok(new { obj = "Place added successfully" });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region Update
        // PUT api/<PlaceController>/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(UpdatePlace place)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                bool updated = await _service.Update(place);
                if (!updated)
                    return NotFound($"Place with ID {place.IdPlace} not found or could not be updated.");

                return Ok(new { obj = "Place updated successfully" });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region Delete
        // DELETE api/<PlaceController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                bool deleted = await _service.Delete(id);
                if (!deleted)
                    return NotFound($"Place with ID {id} not found or could not be deleted.");

                return Ok(new { obj = "Place deleted successfully" });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion
    }
}