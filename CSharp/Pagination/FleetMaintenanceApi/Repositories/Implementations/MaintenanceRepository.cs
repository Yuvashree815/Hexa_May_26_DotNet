using FleetMaintenanceApi.Data;
using FleetMaintenanceApi.Models;
using FleetMaintenanceApi.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FleetMaintenanceApi.Repositories.Implementations
{
    public class MaintenanceRepository : IMaintenanceRepository
    {
        private readonly FleetMaintenanceDbContext _context;
        public MaintenanceRepository(FleetMaintenanceDbContext context)
        {
            _context = context;
        }
        public IQueryable<MaintenanceRecord> GetMaintenanceRecordsQueryable()
        {
            return _context.MaintenanceRecords
                .Include(m => m.Vehicle)
                .Include(m => m.Driver)
                .AsQueryable();
        }
        public async Task AddMaintenanceRecordAsync(MaintenanceRecord maintenanceRecord)
        {
            await _context.MaintenanceRecords.AddAsync(maintenanceRecord);
            await _context.SaveChangesAsync();
        }
    }
}
