using FleetMaintenanceApi.Dtos;

namespace FleetMaintenanceApi.Services.Interfaces
{
    public interface IMaintenanceService
    {
        Task<(bool Success,
              string Message,
              PagedResponseDto<MaintenanceResponseDto>? Data)>
              GetPagedMaintenanceRecordsAsync(
                  MaintenanceFilterRequestDto filter);

        Task<(bool Success,
              string Message,
              MaintenanceResponseDto? Data)>
              AddMaintenanceRecordAsync(
                  MaintenanceCreateDto maintenanceCreateDto);
    }
}
