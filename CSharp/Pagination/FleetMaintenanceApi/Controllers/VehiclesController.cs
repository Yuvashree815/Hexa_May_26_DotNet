using FleetMaintenanceApi.Dtos;

using FleetMaintenanceApi.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FleetMaintenanceApi.Controllers;

[Route("api/vehicles")]
[ApiController]
public class VehiclesController : ControllerBase
{
    private readonly IVehicleService _vehicleService;

    public VehiclesController(IVehicleService vehicleService)
    {
        _vehicleService = vehicleService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllVehicles()
    {
        var vehicles = await _vehicleService.GetAllVehiclesAsync();

        return Ok(new
        {
            statusCode = 200,
            message = "Vehicles retrieved successfully",
            data = vehicles
        });
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetVehicleById(int id)
    {
        if (id <= 0)
        {
            return BadRequest(new
            {
                statusCode = 400,
                message = "Vehicle id must be greater than zero"
            });
        }

        var vehicle = await _vehicleService.GetVehicleByIdAsync(id);

        if (vehicle == null)
        {
            return NotFound(new
            {
                statusCode = 404,
                message = "Vehicle not found"
            });
        }

        return Ok(new
        {
            statusCode = 200,
            message = "Vehicle retrieved successfully",
            data = vehicle
        });
    }

    [HttpPost]
    public async Task<IActionResult> AddVehicle(VehicleCreateDto vehicleCreateDto)
    {
        var result = await _vehicleService.AddVehicleAsync(vehicleCreateDto);

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