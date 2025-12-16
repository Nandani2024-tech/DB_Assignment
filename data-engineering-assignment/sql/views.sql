-- =====================================================
-- VIEWS
-- =====================================================

-- 1. View: students with department names
CREATE OR REPLACE VIEW vw_students_with_departments AS
SELECT
    s.id,
    s.name,
    s.email,
    s.year,
    d.name AS department_name
FROM students s
LEFT JOIN departments d
    ON s.department_id = d.id;


-- 2. View: course enrollment summary
CREATE OR REPLACE VIEW vw_course_enrollments AS
SELECT
    c.id,
    c.name AS course_name,
    COUNT(e.id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e
    ON e.course_id = c.id
GROUP BY c.id, c.name;


-- 3. View: department performance report
CREATE OR REPLACE VIEW vw_department_performance AS
SELECT
    d.name AS department_name,
    COUNT(DISTINCT s.id) AS total_students,
    COUNT(e.id) AS total_enrollments,
    ROUND(AVG(e.grade), 2) AS avg_grade
FROM departments d
LEFT JOIN students s
    ON s.department_id = d.id
LEFT JOIN enrollments e
    ON e.student_id = s.id
GROUP BY d.name;
