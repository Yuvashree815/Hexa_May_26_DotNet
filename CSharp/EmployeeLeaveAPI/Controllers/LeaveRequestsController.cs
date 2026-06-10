using EmployeeLeaveAPI.DTOs;
using EmployeeLeaveAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeLeaveAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LeaveRequestsController : ControllerBase
    {
        private readonly ILeaveRequestService service;

        public LeaveRequestsController(ILeaveRequestService service)
        {
            this.service=service;
        }

        [HttpPost]
        public ActionResult<LeaveRequestResponseDto> Create(LeaveRequestCreateDto dto)
        {
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = service.CreateLeaveRequest (dto);

            return Ok(result);
        }

        [HttpGet]
        public ActionResult<List<LeaveRequestResponseDto>> GetAll()
        {
            return Ok(service.GetAll());
        }

        [HttpGet("{id}")]
        public ActionResult<LeaveRequestResponseDto> GetById(int id)
        {
            var request = service.GetById(id);

            if (request == null)
                return NotFound();

            return Ok(request);
        }



    }
}
