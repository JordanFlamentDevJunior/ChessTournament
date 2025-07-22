using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using BLL.RoleService;
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
                return NotFound("Service is not available");

            try
            {
                IEnumerable<RoleFull> roles = await _service.GetAll();

                if (roles == null)
                    return NotFound("No roles found.");

                return Ok(new { obj = roles });
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
        // GET api/<RoleController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                RoleFull role = await _service.GetById(id);

                if (role == null)
                    return NotFound($"Role with ID {id} not found.");

                return Ok(new { obj = role });
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
        // POST api/<RoleController>
        [HttpPost]
        public async Task<IActionResult> Add(AddRole role)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if(!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                int newId = await _service.Add( new AddRole
                {
                    NameRole = role.NameRole.Trim().ToLower()
                });

                if (newId == -1)
                    return BadRequest("Failed to add the role.");

                return Ok(new { message = "Role added successfully." });
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
        // DELETE api/<RoleController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            try
            {
                bool result = await _service.Delete(id);

                if (!result)
                    return NotFound($"Role with ID {id} not found or could not be deleted.");

                return Ok(new { message = "Role deleted successfully." });
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