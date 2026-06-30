import { useNavigate } from "react-router-dom";

function CourseCard({ course }) {

  const navigate = useNavigate();

  return (

    <div className="course-card">

      <h2>{course.title}</h2>

      <p>
        <strong>Category:</strong> {course.category}
      </p>

      <p>
        <strong>Duration:</strong> {course.duration}
      </p>

      <p>
        <strong>Trainer:</strong> {course.trainer}
      </p>

      <button
        onClick={() => navigate(`/courses/${course.id}`)}
      >
        View Details
      </button>

    </div>

  );
}

export default CourseCard;