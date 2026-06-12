using FleetMaintenanceApi.Dtos;

using FleetMaintenanceApi.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FleetMaintenanceApi.Controllers;

[Route("api/drivers")]
[ApiController]
public class DriversController : ControllerBase
{
    private readonly IDriverService _driverService;

    public DriversController(IDriverService driverService)
    {
        _driverService = driverService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllDrivers()
    {
        var drivers = await _driverService.GetAllDriversAsync();

        return Ok(new
        {
            statusCode = 200,
            message = "Drivers retrieved successfully",
            data = drivers
        });
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetDriverById(int id)
    {
        if (id <= 0)
        {
            return BadRequest(new
            {
                statusCode = 400,
                message = "Driver id must be greater than zero"
            });
        }

        var driver = await _driverService.GetDriverByIdAsync(id);

        if (driver == null)
        {
            return NotFound(new
            {
                statusCode = 404,
                message = "Driver not found"
            });
        }

        return Ok(new
        {
            statusCode = 200,
            message = "Driver retrieved successfully",
            data = driver
        });
    }

    [HttpPost]
    public async Task<IActionResult> AddDriver(DriverCreateDto driverCreateDto)
    {
        var result = await _driverService.AddDriverAsync(driverCreateDto);

        if (!result.Success)
        {
            return BadRequest(new
            {
                statusCode = 400,
                message = result.Message
            });
        }

        return Ok(new
        {
            statusCode = 200,
            message = result.Message,
            data = result.Data
        });
    }
}