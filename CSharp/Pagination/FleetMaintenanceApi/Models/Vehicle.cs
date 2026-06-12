using System;
using System.Collections.Generic;

namespace FleetMaintenanceApi.Models;

public partial class Vehicle
{
    public int VehicleId { get; set; }

    public string VehicleNumber { get; set; } = null!;

    public string VehicleType { get; set; } = null!;

    public string Brand { get; set; } = null!;

    public string Model { get; set; } = null!;

    public int PurchaseYear { get; set; }

    public bool IsActive { get; set; }

    public virtual ICollection<MaintenanceRecord> MaintenanceRecords { get; set; } = new List<MaintenanceRecord>();
}
