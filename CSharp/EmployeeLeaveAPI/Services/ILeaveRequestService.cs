using EmployeeLeaveAPI.DTOs;

namespace EmployeeLeaveAPI.Services
{
    public interface ILeaveRequestService
    {
        LeaveRequestResponseDto CreateLeaveRequest(LeaveRequestCreateDto dto);
        List<LeaveRequestResponseDto> GetAll();
        LeaveRequestResponseDto GetById(int id);

    }
}
