using EmployeeLeaveAPI.DTOs;
using EmployeeLeaveAPI.Models;
using Microsoft.AspNetCore.Http.HttpResults;
using System.Net.NetworkInformation;

namespace EmployeeLeaveAPI.Services
{
    public class LeaveRequestService : ILeaveRequestService
    {
        private static List<LeaveRequest> requests = new List<LeaveRequest>();

        private static int currentId = 1;
        public LeaveRequestResponseDto CreateLeaveRequest(LeaveRequestCreateDto dto)
        {
            //(20-Jun - 25-Jun).Days + 1     -5 + 1 = -4      

            if (dto.EndDate < dto.StartDate)
            {
                throw new Exception("End Date cannot be earlier than Start Date");
            }

            var leaveRequest = new LeaveRequest
            {
                LeaveRequestId = currentId++, // 1++

                EmployeeName = dto.EmployeeName,

                EmployeeEmail = dto.EmployeeEmail,

                MobileNumber = dto.MobileNumber,

                LeaveType = dto.LeaveType,

                StartDate = dto.StartDate,

                EndDate = dto.EndDate,

                Reason = dto.Reason,

                TotalDays = (dto.EndDate - dto.StartDate).Days + 1,  // if 22-06-2026 - 20-06-2026 means totally 3 days but (22-20)=2 so we are ading 1

                Status = "Pending",

                CreatedOn = DateTime.Now
            };

            requests.Add(leaveRequest);

            return MapToResponse(leaveRequest);

        }

        public List<LeaveRequestResponseDto> GetAll()
        {
            return requests.Select(MapToResponse).ToList();
        }

        public LeaveRequestResponseDto GetById(int id)
        {
            var request = requests.FirstOrDefault(x =>  x.LeaveRequestId == id);

            if(request == null)
            {
                return null;
            }
            return MapToResponse(request);
        }

        private LeaveRequestResponseDto MapToResponse(LeaveRequest request)
        {
            return new LeaveRequestResponseDto
            {
                LeaveRequestId = request.LeaveRequestId,

                EmployeeName = request.EmployeeName,

                EmployeeEmail = request.EmployeeEmail,

                LeaveType = request.LeaveType,

                StartDate = request.StartDate,

                EndDate = request.EndDate,

                Reason = request.Reason,

                TotalDays = request.TotalDays,

                Status = request.Status,

                CreatedOn = request.CreatedOn
            };
        }
    }
}
