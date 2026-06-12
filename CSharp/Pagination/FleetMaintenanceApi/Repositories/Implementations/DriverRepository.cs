using FleetMaintenanceApi.Data;
using FleetMaintenanceApi.Models;
using FleetMaintenanceApi.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FleetMaintenanceApi.Repositories.Implementations
{
    public class DriverRepository : IDriverRepository
    {
        private readonly FleetMaintenanceDbContext _context;

        public DriverRepository(FleetMaintenanceDbContext context)
        {
            _context = context;
        }
        public async Task<List<Driver>> GetAllDriversAsync()
        {
            return await _context.Drivers.ToListAsync();
        }
        public async Task<Driver?> GetDriverByIdAsync(int driverId)
        {
            return await _context.Drivers.FirstOrDefaultAsync(d => d.DriverId == driverId);

        }
        public async Task AddDriverAsync(Driver driver)
        {
            await _context.Drivers.AddAsync(driver);
            await _context.SaveChangesAsync();
        }
        public async Task<bool> DriverExistsAsync(int driverId)
        {
            return await _context.Drivers.AnyAsync(d => d.DriverId == driverId);
        }
    }
}
