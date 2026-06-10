using System.ComponentModel.DataAnnotations;

namespace EmployeeLeaveAPI.Validations
{
    public class ValidLeaveTypeAttribute : ValidationAttribute
    {
        private readonly string[] allowedTypes = new string[]
        {
            "Sick",
            "Casual",
            "Earned"
        };

        protected override ValidationResult? IsValid (object? value, ValidationContext validationContext)
        {
            if(value == null)
            {
                return new ValidationResult("Leave Type is required");
            }

            string leaveType = value.ToString();
            if(!allowedTypes.Contains(leaveType))
            {
                return new ValidationResult("LeaveType must be Sick, Casual, Earned");
            }
            return ValidationResult.Success;
        }
    }
}
