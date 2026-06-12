using FleetMaintenanceApi.Models;

namespace FleetMaintenanceApi.Repositories.Interfaces
{
    public interface IMaintenanceRepository
    {
        IQueryable<MaintenanceRecord> GetMaintenanceRecordsQueryable();

        Task AddMaintenanceRecordAsync(MaintenanceRecord maintenanceRecord);
    }
}
