-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- 1. Procedure: Get students by department
CREATE OR REPLACE FUNCTION get_students_by_department(dept_name TEXT)
RETURNS TABLE (
    student_name TEXT,
    email TEXT,
    year INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.name,
        s.email,
        s.year
    FROM students s
    JOIN departments d
        ON s.department_id = d.id
    WHERE d.name = dept_name;
END;
$$ LANGUAGE plpgsql;


-- 2. Procedure: Get course enrollment count
CREATE OR REPLACE FUNCTION get_course_enrollment_count(course_name TEXT)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(e.id)
    INTO total
    FROM enrollments e
    JOIN courses c
        ON e.course_id = c.id
    WHERE c.name = course_name;

    RETURN total;
END;
$$ LANGUAGE plpgsql;
