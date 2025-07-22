using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using BLL.StatusService;
using Models.Status;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StatusController : ControllerBase
    {
        private readonly IStatusService _service;
        public StatusController(IStatusService service)
        {
            _service = service;
        }

        #region GetAll
        // GET: api/<StatusController>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                IEnumerable<StatusFull> status = await _service.GetAll();

                if (status == null)
                    return NotFound("No statuses found.");

                return Ok(new { obj = status });
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
        // GET api/<StatusController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                StatusFull status = await _service.GetById(id);

                if (status == null)
                    return NotFound($"Status with ID {id} not found.");

                return Ok(new { obj = status });
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
        // POST api/<StatusController>
        [HttpPost]
        public async Task<IActionResult> Add(AddStatus status)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest("Invalid status data.");

            try
            {
                int id = await _service.Add(new AddStatus
                {
                    NameStatus = status.NameStatus.Trim().ToLower()
                });
                
                if(id == -1)
                    return BadRequest("Failed to add status.");

                return Ok(new { obj = "Status added successfully" });
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
        // DELETE api/<StatusController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                bool deleted = await _service.Delete(id);

                if (!deleted)
                    return NotFound($"Status with ID {id} not found or could not be deleted.");

                return Ok(new { obj = "Status deleted successfully" });
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
