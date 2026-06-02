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
        public bool IsValid()
        {
            return AppointmentId > 0 &&
                   !string.IsNullOrWhiteSpace(PatientName) &&
                   !string.IsNullOrWhiteSpace(Department) &&
                   !string.IsNullOrWhiteSpace(Status) &&
                   ConsultationFee >= 0;
        }
    }
}
