using System.ComponentModel.DataAnnotations;

namespace EmployeeLeaveAPI.Validations
{
    public class FutureDateAttribute : ValidationAttribute
    {
        protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
        {
            if(value == null)
            {
                return new ValidationResult("Date is required");
            }
            DateTime date = (DateTime)value;

            if(DateTime.Today >=date.Date)
            {
                return new ValidationResult("Date must be Future Date");
            }
            return ValidationResult.Success;
        }
    }
}
