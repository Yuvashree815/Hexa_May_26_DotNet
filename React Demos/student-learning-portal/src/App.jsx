import { Routes, Route } from "react-router-dom";

import MainLayout from "./layouts/MainLayout";
import DashboardLayout from "./layouts/DashboardLayout";
import ProtectedRoute from "./routes/ProtectedRoute";

import Home from "./pages/Home";
import About from "./pages/About";
import Courses from "./pages/Courses";
import CourseDetails from "./pages/CourseDetails";
import Contact from "./pages/Contact";
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import Profile from "./pages/Profile";
import MyCourses from "./pages/MyCourses";
import Settings from "./pages/Settings";
import NotFound from "./pages/NotFound";

function App() {
  return (
    <Routes>

      {/* Public Layout */}

      <Route path="/" element={<MainLayout />}>

        <Route index element={<Home />} />

        <Route path="about" element={<About />} />

        <Route path="courses" element={<Courses />} />

        <Route path="courses/:courseId" element={<CourseDetails />} />

        <Route path="contact" element={<Contact />} />

        <Route path="login" element={<Login />} />

      </Route>

      {/* Protected Dashboard */}

      <Route
        path="/dashboard"
        element={
          <ProtectedRoute>
            <DashboardLayout />
          </ProtectedRoute>
        }
      >

        <Route index element={<Dashboard />} />

        <Route path="profile" element={<Profile />} />

        <Route path="my-courses" element={<MyCourses />} />

        <Route path="settings" element={<Settings />} />

      </Route>

      {/* 404 */}

      <Route path="*" element={<NotFound />} />

    </Routes>
  );
}

export default App;