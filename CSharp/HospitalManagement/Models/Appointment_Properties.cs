using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;

namespace HospitalManagement.Models
{
    public partial class Appointment
    {
        public int AppointmentId { get; set; }
        public string PatientName { get; set; }
        public string Department { get; set; } 
        public DateTime AppointmentDate { get; set; }
        public string Status { get; set; } 
        public double ConsultationFee { get; set; }
    }
    
}
