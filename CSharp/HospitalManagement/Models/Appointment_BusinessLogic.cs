using System;

namespace HospitalManagement.Models
{
    public partial class Appointment
    {
        public void Display()
        {
            Console.WriteLine($"{AppointmentId} | {PatientName} | {Department} | {AppointmentDate:dd-MM-yyyy} | {Status} | {ConsultationFee}");
        }

        public bool IsUpcoming()
        {
            return AppointmentDate > DateTime.Today &&
                   Status == "Scheduled";
        }
    }
}