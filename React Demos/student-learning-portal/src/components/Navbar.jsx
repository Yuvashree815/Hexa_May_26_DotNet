import { NavLink, useNavigate } from "react-router-dom";

function Navbar() {

  const navigate = useNavigate();

  const isLoggedIn = localStorage.getItem("isLoggedIn");

  function handleLogout() {

    localStorage.removeItem("isLoggedIn");

    navigate("/login");
  }

  return (

    <nav className="navbar">

      <div className="logo">
        Student Portal
      </div>

      <div className="nav-links">

        <NavLink to="/">Home</NavLink>

        <NavLink to="/about">About</NavLink>

        <NavLink to="/courses">Courses</NavLink>

        <NavLink to="/contact">Contact</NavLink>

        {!isLoggedIn ? (

          <NavLink to="/login">Login</NavLink>

        ) : (

          <>
            <NavLink to="/dashboard">
              Dashboard
            </NavLink>

            <button onClick={handleLogout}>
              Logout
            </button>
          </>

        )}

      </div>

    </nav>

  );
}

export default Navbar;