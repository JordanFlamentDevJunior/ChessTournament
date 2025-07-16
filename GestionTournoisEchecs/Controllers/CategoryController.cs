using Microsoft.AspNetCore.Mvc;
using BLL.CategoryService;
using Models.Category;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

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
            {
                return NotFound("Service is not available");
            }

            IEnumerable<CategoryFull> categories = await _service.GetAll();
            return Ok(categories);
        }
        #endregion

        #region GetById
        // GET api/<CategoryController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            CategoryFull category = await _service.GetById(id);
            return Ok(category);
        }
        #endregion

        #region Add
        // POST api/<CategoryController>
        [HttpPost]
        public async Task<IActionResult> Add(AddCategory category)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            Guid newId = await _service.Add(category);
            return Ok(newId);
        }
        #endregion

        #region Update
        // PUT api/<CategoryController>/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(UpdateCategory category)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            bool isUpdated = await _service.Update(category);
            if (isUpdated)
            {
                return Ok("Category updated successfully");
            }
            else
            {
                return NotFound("Category not found");
            }
        }
        #endregion

        #region Delete

        // DELETE api/<CategoryController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            bool isDeleted = await _service.Delete(id);
            if (isDeleted)
            {
                return Ok("Category deleted successfully");
            }
            else
            {
                return NotFound("Category not found");
            }
        }
        #endregion
    }
}