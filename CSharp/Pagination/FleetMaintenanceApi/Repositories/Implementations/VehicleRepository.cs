using FleetMaintenanceApi.Data;
using FleetMaintenanceApi.Models;
using FleetMaintenanceApi.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FleetMaintenanceApi.Repositories.Implementations
{
    public class VehicleRepository : IVehicleRepository
    {
        private readonly FleetMaintenanceDbContext _context;

        public VehicleRepository(FleetMaintenanceDbContext context)
        {
            _context=context;
        }
        public async Task<List<Vehicle>> GetAllVehiclesAsync()
        {
            return await _context.Vehicles.ToListAsync();
        }
        public async Task<Vehicle?> GetVehicleByIdAsync(int vehicleId)
        {
            return await _context.Vehicles.FirstOrDefaultAsync(v => v.VehicleId == vehicleId);

        }
        public async Task AddVehicleAsync(Vehicle vehicle)
        {
            await _context.Vehicles.AddAsync(vehicle);
            await _context.SaveChangesAsync();
        }
        public async Task<bool> VehicleExistsAsync(int vehicleId)
        {
            return await _context.Vehicles.AnyAsync(v=>v.VehicleId== vehicleId);
        }

    }
}
