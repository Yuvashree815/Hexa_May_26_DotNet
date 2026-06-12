namespace FleetMaintenanceApi.Dtos
{
    public class MaintenanceCreateDto
    {
        public int VehicleId { get; set; }

        public int DriverId { get; set; }

        public DateOnly ServiceDate { get; set; }

        public string ServiceType { get; set; } = String.Empty;

        public decimal ServiceCost { get; set; }

        public string ServiceStatus { get; set; } = String.Empty;

        public string? Remarks { get; set; }
    }
}
