using System;
using System.Collections.Generic;

namespace FleetMaintenanceApi.Models;

public partial class MaintenanceRecord
{
    public int MaintenanceId { get; set; }

    public int VehicleId { get; set; }

    public int DriverId { get; set; }

    public DateOnly ServiceDate { get; set; }

    public string ServiceType { get; set; } = null!;

    public decimal ServiceCost { get; set; }

    public string ServiceStatus { get; set; } = null!;

    public string? Remarks { get; set; }

    public DateTime CreatedDate { get; set; }

    public virtual Driver Driver { get; set; } = null!;

    public virtual Vehicle Vehicle { get; set; } = null!;
}
