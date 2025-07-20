using BLL.RoleService;
using Microsoft.AspNetCore.Mvc;
using Models.Role;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RoleController : ControllerBase
    {
        private readonly IRoleService _service;

        public RoleController(IRoleService service)
        {
            _service = service;
        }

        #region GetAll
        // GET: api/<RoleController>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            if (_service == null)
            {
                return NotFound("Service is not available");
            }
            IEnumerable<RoleFull> roles = await _service.GetAll();
            if (roles == null || !roles.Any())
            {
                return NotFound("No roles found.");
            }
            return Ok(roles);
        }
        #endregion

        #region GetById
        // GET api/<RoleController>/1
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(byte id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            RoleFull role = await _service.GetById(id);
            if (role == null)
            {
                return NotFound($"Role with ID {id} not found.");
            }
            return Ok(role);
        }
        #endregion

        #region Add
        // POST api/<RoleController>
        [HttpPost]
        public async Task<IActionResult> Add(AddRole role)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            byte newId = await _service.Add(role);
            if (newId == 255)
            {
                return BadRequest("The role could not be added. It may already exist or be invalid.");
            }
            return Ok($"The new role was added successfully with ID: {newId}");
        }
        #endregion

        #region Delete
        // DELETE api/<RoleController>/1
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(byte id)
        {
            bool isDeleted = await _service.Delete(id);
            if (!isDeleted)
            {
                return NotFound("Role not found or could not be deleted");
            }
            return Ok("The role was deleted successfully");
        }
        #endregion
    }
}