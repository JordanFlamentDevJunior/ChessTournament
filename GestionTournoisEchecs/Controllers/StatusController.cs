using BLL.StatusService;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
            {
                return NotFound("Service is not available");
            }
            IEnumerable<StatusFull> roles = await _service.GetAll();
            if (roles == null || !roles.Any())
            {
                return NotFound("No statuses found.");
            }
            return Ok(roles);
        }
        #endregion

        #region GetById
        // GET api/<StatusController>/1
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(byte id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            StatusFull status = await _service.GetById(id);
            if (status == null)
            {
                return NotFound($"Status with ID {id} not found.");
            }
            return Ok(status);
        }
        #endregion

        #region Add
        // POST api/<StatusController>
        [HttpPost]
        public async Task<IActionResult> Add(AddStatus status)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            byte newId = await _service.Add(status);
            if (newId == 255)
            {
                return BadRequest("Le statut n’a pas pu être ajouté. Il est peut-être déjà existant ou invalide.");
            }
            return Ok($"The new status was added successfully with ID: {newId}");
        }
        #endregion

        #region Delete
        // DELETE api/<StatusController>/1
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(byte id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            bool isDeleted = await _service.Delete(id);
            if (!isDeleted)
            {
                return NotFound("Status not found.");
            }
            return Ok("Status deleted successfully.");
        }
        #endregion
    }
}