using BLL.GenderService;
using Microsoft.AspNetCore.Mvc;
using Models.Gender;

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
            {
                return NotFound("Service is not available");
            }

            IEnumerable<GenderFull> genres = await _service.GetAll();
            // verifier si les genres sont valide sinon retourner erreur 
            if (genres == null || !genres.Any())
            {
                return NotFound("No gender's finding");
            }
            return Ok(genres);
        }
        #endregion

        #region GetById
        // GET api/<GenderController>/1
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(byte id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            GenderFull genre = await _service.GetById(id);
            if (genre == null)
            {
                return NotFound($"Gender not found id's : {id}.");
            }
            return Ok(genre);
        }
        #endregion

        #region Add
        // POST api/<GenderController>
        [HttpPost]
        public async Task<IActionResult> Add(AddGender genre)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            byte newId = await _service.Add(genre);
            if (newId == 255)
            {
                return BadRequest("Le genre n’a pas pu être ajouté. Il est peut-être déjà existant ou invalide.");
            }
            return Ok($"The new gender was added successfully Id's {newId}");
        }
        #endregion

        #region Delete
        // DELETE api/<GenderController>/1
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(byte id)
        {
            bool isDeleted = await _service.Delete(id);
            if (!isDeleted)
            {
                return NotFound("The deletion of gender was failed successfully");
            }
            return Ok("Gender deleted successfully");
        }
        #endregion
    }
}