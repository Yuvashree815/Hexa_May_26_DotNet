import courses from "../data/courses";
import CourseCard from "../components/CourseCard";

function Courses() {

  return (

    <div>

      <h1>Available Courses</h1>

      <br />

      <div className="course-grid">
    {courses.map(course => (
        <CourseCard
            key={course.id}
            course={course}
        />
    ))}
</div>

    </div>

  );
}

export default Courses;