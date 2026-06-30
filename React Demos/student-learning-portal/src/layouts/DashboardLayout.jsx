import { NavLink, Outlet } from "react-router-dom";

function DashboardLayout() {
  return (
    <div className="container">

      <h1>Student Dashboard</h1>

      <nav className="dashboard-nav">

        <NavLink to="/dashboard/profile">
          Profile
        </NavLink>

        <NavLink to="/dashboard/my-courses">
          My Courses
        </NavLink>

        <NavLink to="/dashboard/settings">
          Settings
        </NavLink>

      </nav>

      <Outlet />

    </div>
  );
}

export default DashboardLayout;