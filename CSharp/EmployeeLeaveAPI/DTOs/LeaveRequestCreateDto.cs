using EmployeeLeaveAPI.Validations;
using System.ComponentModel.DataAnnotations;

namespace EmployeeLeaveAPI.DTOs
{
    public class LeaveRequestCreateDto
    {
        [Required(ErrorMessage ="Employee Name is required")]
        [StringLength(30,MinimumLength =3,ErrorMessage ="Employee name must be between 3 and 30")]
        public string EmployeeName { get; set; }

        [Required(ErrorMessage = "Employee Email is required")]
        [EmailAddress(ErrorMessage ="InvalidEmailAddress")]
        public string EmployeeEmail { get; set; }

        [Required(ErrorMessage = "Employee Mobile Number is required")]
        [Phone(ErrorMessage ="Invalid Mobile Number")]
        public string MobileNumber { get; set; }

        [Required(ErrorMessage = "Leave Type is required")]
        [ValidLeaveType(ErrorMessage = "LeaveType must be Sick, Casual, Earned")]
        public string LeaveType { get; set; }

        [Required(ErrorMessage ="Start Date is required")]
        [FutureDate(ErrorMessage= "Date must be Future Date")]
        public DateTime StartDate { get; set; }


        [Required(ErrorMessage = "End Date is required")]
        [FutureDate(ErrorMessage = "Date must be Future Date")]
        public DateTime EndDate { get; set; }

        [Required(ErrorMessage = "Reason is required")]
        [StringLength(250, MinimumLength =10, ErrorMessage ="Leave Reason must be between 10 and 250 characters")]
        public string Reason { get; set; }
       
    }
}
