using Microsoft.AspNetCore.Mvc;
using Models.Gender;
using BLL.GenderService;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GenderController : ControllerBase
    {
        private readonly IGenderService _service;

        public GenderController(IGenderService service)
        {
            _service = service;
        }

        #region GetAll

        // GET: api/<GenderController>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                IEnumerable<GenderFull> genders = await _service.GetAll();
                if (genders == null)
                    return NotFound("No gender found.");

                return Ok(new { obj = genders });
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
        // GET api/<GenderController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                GenderFull gender = await _service.GetById(id);
                // verifier si la category est valide sinon retourner erreur 

                if (gender == null)
                    return NotFound($"Gender with ID {id} not found.");

                return Ok(new { obj = gender });
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
        // POST api/<GenderController>
        [HttpPost]
        public async Task<IActionResult> Add(AddGender gender)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                int newId = await _service.Add(new AddGender
                {
                    NameGender = gender.NameGender.Trim().ToLower(),
                });

                if (newId == -1)
                    return BadRequest("The gender could not be added. It may already exist or be invalid.");

                return Ok(new { message = "Gender added successfully." });
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
        // DELETE api/<GenderController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                bool isDeleted = await _service.Delete(id);
                if (!isDeleted)
                    return BadRequest("The deletion of gender was failed successfully");

                return Ok(new { message = "Gender deleted successfully." });
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
