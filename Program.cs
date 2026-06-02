using System;
using System.Collections.Generic;
using System.Linq;
using HospitalManagement.Models;


namespace HospitalManagement
{
    class Program
    {
        static void Main()
        {
            List<Appointment> appointments = new List<Appointment>
        {
            new Appointment { AppointmentId = 1, PatientName = "Ravi", Department = "Cardiology", AppointmentDate = DateTime.Today.AddDays(2), Status = "Scheduled", ConsultationFee = 700 },
            new Appointment { AppointmentId = 2, PatientName = "Priya", Department = "Neurology", AppointmentDate = DateTime.Today.AddDays(-1), Status = "Completed", ConsultationFee = 600 },
            new Appointment { AppointmentId = 3, PatientName = "Kumar", Department = "Cardiology", AppointmentDate = DateTime.Today.AddDays(-3), Status = "Completed", ConsultationFee = 800 },
            new Appointment { AppointmentId = 4, PatientName = "Anu", Department = "Dermatology", AppointmentDate = DateTime.Today.AddDays(5), Status = "Scheduled", ConsultationFee = 400 },
            new Appointment { AppointmentId = 5, PatientName = "Meena", Department = "Orthopedics", AppointmentDate = DateTime.Today, Status = "Cancelled", ConsultationFee = 500 }
        };

            Console.WriteLine("All Appointments:");
            appointments.ForEach(a => a.Display());

            Console.WriteLine("\nScheduled Appointments:");
            appointments.Where(a => a.Status == "Scheduled").ToList().ForEach(a => a.Display());

            Console.WriteLine("\nCompleted Appointments:");
            appointments.Where(a => a.Status == "Completed").ToList().ForEach(a => a.Display());

            Console.WriteLine("\nCardiology Appointments:");
            appointments.Where(a => a.Department == "Cardiology").ToList().ForEach(a => a.Display());

            Console.WriteLine("\nConsultation Fee Greater Than 500:");
            appointments.Where(a => a.ConsultationFee > 500).ToList().ForEach(a => a.Display());

            Console.WriteLine("\nSorted By Appointment Date:");
            appointments.OrderBy(a => a.AppointmentDate).ToList().ForEach(a => a.Display());

            Console.WriteLine("\nSearch Appointment By Patient Name:");
            string searchName = "Priya";
            appointments.Where(a => a.PatientName.Equals(searchName, StringComparison.OrdinalIgnoreCase))
                        .ToList()
                        .ForEach(a => a.Display());

            Console.WriteLine("\nGroup Appointments By Department:");
            var departmentGroups = appointments.GroupBy(a => a.Department);
            foreach (var group in departmentGroups)
            {
                Console.WriteLine($"\nDepartment: {group.Key}");
                foreach (var appointment in group)
                {
                    appointment.Display();
                }
            }

            Console.WriteLine("\nCount Appointments By Status:");
            var statusCounts = appointments.GroupBy(a => a.Status);
            foreach (var group in statusCounts)
            {
                Console.WriteLine($"{group.Key}: {group.Count()}");
            }

            double totalRevenue = appointments
                .Where(a => a.Status == "Completed")
                .Sum(a => a.ConsultationFee);

            Console.WriteLine($"\nTotal Revenue From Completed Appointments: {totalRevenue}");

            double averageFee = appointments.Average(a => a.ConsultationFee);
            Console.WriteLine($"\nAverage Consultation Fee: {averageFee}");

            Console.WriteLine("\nUpcoming Appointments:");
            appointments.Where(a => a.IsUpcoming()).ToList().ForEach(a => a.Display());

            Console.ReadLine();
        }

    }
}