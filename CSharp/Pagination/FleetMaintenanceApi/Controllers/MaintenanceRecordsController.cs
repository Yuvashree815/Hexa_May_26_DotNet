using FleetMaintenanceApi.Dtos;

using FleetMaintenanceApi.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FleetMaintenanceApi.Controllers;

[Route("api/maintenanceRecords")]
[ApiController]
public class MaintenanceRecordsController : ControllerBase
{
    private readonly IMaintenanceService _maintenanceService;

    public MaintenanceRecordsController(IMaintenanceService maintenanceService)
    {
        _maintenanceService = maintenanceService;
    }

    [HttpGet]
    public async Task<IActionResult> GetMaintenanceRecords([FromQuery] MaintenanceFilterRequestDto filter)
    {
        var result = await _maintenanceService.GetPagedMaintenanceRecordsAsync(filter);

        if (!result.Success)
        {
            return BadRequest(new
            {
                statusCode = 400,
                message = result.Message
            });
        }

        return Ok(result.Data);
    }

    [HttpPost]
    public async Task<IActionResult> AddMaintenanceRecord(MaintenanceCreateDto maintenanceCreateDto)
    {
        var result = await _maintenanceService.AddMaintenanceRecordAsync(maintenanceCreateDto);

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