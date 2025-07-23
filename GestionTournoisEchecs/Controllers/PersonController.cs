using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Models.Person;
using BLL.PersonService;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PersonController : ControllerBase
    {
        private readonly IPersonService _service;

        public PersonController(IPersonService service)
        {
            _service = service;
        }

        #region GetAll
        // GET: api/<PersonController>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                IEnumerable<PersonFull> persons = await _service.GetAll();
                if (persons == null)
                    return NotFound("No persons found.");

                return Ok(new { obj = persons });
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
        // GET api/<PersonController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                PersonFull person = await _service.GetById(id);
                if (person == null)
                    return NotFound($"Person with ID {id} not found.");

                return Ok(new { obj = person });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region AddPerson
        // POST api/<PersonController>
        [HttpPost]
        public async Task<IActionResult> AddPerson(AddPerson person)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                int newId = await _service.Add(new AddPerson
                {
                    Pseudo = person.Pseudo.Trim().ToLower(),
                    Gender = person.Gender,
                    Mail = person.Mail.Trim().ToLower(),
                    Password = person.Password.Trim(),
                    DateOfBirth = person.DateOfBirth,
                    Role = person.Role,
                    Elo = person.Elo
                });

                if (newId == -1)
                    return BadRequest("Failed to add person.");

                return Ok(new { message = "Person added successfully" });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region UpdatePerson
        // PUT api/<PersonController>/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePerson(UpdatePerson person)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                bool updated = await _service.Update(person);
                if (!updated)
                    return BadRequest("Failed to update person.");

                return Ok(new { message = "Person updated successfully" });
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                Console.WriteLine(ex);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region DeletePerson
        // DELETE api/<PersonController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePerson(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                bool deleted = await _service.Delete(id);
                if (!deleted)
                    return BadRequest($"Person with ID {id} not found or could not be deleted.");
                
                return Ok(new { message = "Person deleted successfully" });
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