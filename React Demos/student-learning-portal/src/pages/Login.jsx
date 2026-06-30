import { useState } from "react";
import { useNavigate } from "react-router-dom";

function Login() {

  const navigate = useNavigate();

  const [username, setUsername] = useState("");

  const [password, setPassword] = useState("");

  const [error, setError] = useState("");

  function handleLogin(e) {

    e.preventDefault();

    if (!username || !password) {
      setError("All fields are required");
      return;
    }

    if (
      username === "student" &&
      password === "student123"
    ) {

      localStorage.setItem("isLoggedIn", "true");

      navigate("/dashboard");

    } else {

      setError("Invalid Username or Password");

    }

  }

  return (

    <div>

      <h1>Login</h1>

      <br />

      <form onSubmit={handleLogin}>

        <input
          type="text"
          placeholder="Username"
          value={username}
          onChange={(e) =>
            setUsername(e.target.value)
          }
        />

        <br /><br />

        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) =>
            setPassword(e.target.value)
          }
        />

        <br /><br />

        <button>
          Login
        </button>

      </form>

      <br />

      <p className="error">{error}</p>

    </div>

  );
}

export default Login;