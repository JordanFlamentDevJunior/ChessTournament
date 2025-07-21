using Microsoft.AspNetCore.Mvc;
using BLL.CategoryService;
using Models.Category;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly ICategoryService _service;

        public CategoryController(ICategoryService service)
        {
            _service = service;
        }

        #region GetAll
        // GET: api/<CategoryController>
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            if(_service == null)
                return NotFound("Service is not available");

            try
            {
                IEnumerable<CategoryFull> categories = await _service.GetAll();
                if (categories == null)
                    return NotFound("No categories found.");

                return Ok(categories);
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region GetById
        // GET api/<CategoryController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(byte id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (id < 0 && id > 2)
                return BadRequest("The ID must be between 0 and 255.");

            try
            {
                CategoryFull category = await _service.GetById(id);
                // verifier si la category est valide sinon retourner erreur 

                if(category == null)
                    return NotFound($"Category with ID {id} not found.");

                return Ok(category);
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region Add
        // POST api/<CategoryController>
        [HttpPost]
        public async Task<IActionResult> Add(AddCategory category)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                byte newId = await _service.Add(new AddCategory
                {
                    NameCategory = category.NameCategory.Trim().ToLower(),
                    MinAge = category.MinAge,
                    MaxAge = category.MaxAge
                });

                if (newId == 255)
                    return BadRequest("The category could not be added. It may already exist or be invalid.");

                return Ok($"The new category was added successfully. New Id :{newId}");
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region Update
        // PUT api/<CategoryController>/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(UpdateCategory category)
        {
            // le update ne fonctionne pas correctement.
            // le nom ne peut pas être mis a jour,
            // mais l'age peut être mis a jour n'importe comment.
            if (_service == null)
                return NotFound("Service is not available");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                bool isUpdated = await _service.Update(category);
                if (!isUpdated)
                    return BadRequest("The update of category was failed successfully");

                return Ok("Category updated successfully");
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region Delete

        // DELETE api/<CategoryController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(byte id)
        {
            if (_service == null)
                return NotFound("Service is not available");

            if ( id >= 0 && id <= 2)
                return BadRequest("The ID must be between 0 and 255.");

            try
            {
                bool isDeleted = await _service.Delete(id);
                if (!isDeleted)
                    return BadRequest("The deletion of category was failed successfully");

                return Ok("Category deleted successfully");
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion
    }
}