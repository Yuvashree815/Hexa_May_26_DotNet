using System;
using System.Collections.Generic;

namespace FleetMaintenanceApi.Models;

public partial class Driver
{
    public int DriverId { get; set; }

    public string DriverName { get; set; } = null!;

    public string LicenseNumber { get; set; } = null!;

    public string PhoneNumber { get; set; } = null!;

    public string City { get; set; } = null!;

    public bool IsAvailable { get; set; }

    public virtual ICollection<MaintenanceRecord> MaintenanceRecords { get; set; } = new List<MaintenanceRecord>();
}
