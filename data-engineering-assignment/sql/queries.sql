-- =====================================================
-- AGGREGATION QUERIES
-- =====================================================

-- 1. Total number of students
SELECT COUNT(*) AS total_students
FROM students;


-- 2. Number of students per department
SELECT
    d.name AS department_name,
    COUNT(s.id) AS student_count
FROM departments d
LEFT JOIN students s
    ON s.department_id = d.id
GROUP BY d.name
ORDER BY student_count DESC;


-- 3. Average year of students (sanity metric)
SELECT
    AVG(year) AS avg_year
FROM students;


-- =====================================================
-- JOIN-HEAVY QUERIES
-- Student ↔ Enrollment ↔ Course
-- =====================================================

-- 4. List all students with their enrolled courses
SELECT
    s.name AS student_name,
    s.email,
    c.name AS course_name
FROM students s
JOIN enrollments e
    ON e.student_id = s.id
JOIN courses c
    ON c.id = e.course_id
ORDER BY s.name;


-- 5. Number of enrollments per course
SELECT
    c.name AS course_name,
    COUNT(e.id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e
    ON e.course_id = c.id
GROUP BY c.name
ORDER BY enrollment_count DESC;


-- 6. Courses taken by students in each department
SELECT
    d.name AS department_name,
    c.name AS course_name,
    COUNT(e.id) AS total_enrollments
FROM departments d
JOIN students s
    ON s.department_id = d.id
JOIN enrollments e
    ON e.student_id = s.id
JOIN courses c
    ON c.id = e.course_id
GROUP BY d.name, c.name
ORDER BY d.name, total_enrollments DESC;

-- =====================================================
-- DATA QUALITY CHECKS
-- =====================================================

-- 7. Detect duplicate students by email
SELECT
    email,
    COUNT(*) AS occurrences
FROM students
GROUP BY email
HAVING COUNT(*) > 1;


-- 8. Students without a department (FK issues)
SELECT
    s.id,
    s.name,
    s.email
FROM students s
LEFT JOIN departments d
    ON s.department_id = d.id
WHERE d.id IS NULL;


-- 9. Enrollments with missing foreign keys
SELECT
    e.id,
    e.student_id,
    e.course_id
FROM enrollments e
LEFT JOIN students s
    ON e.student_id = s.id
LEFT JOIN courses c
    ON e.course_id = c.id
WHERE s.id IS NULL
   OR c.id IS NULL;


-- =====================================================
-- REPORTING QUERIES
-- =====================================================

-- 10. Students per department (official report)
SELECT
    d.name AS department_name,
    COUNT(s.id) AS total_students
FROM departments d
LEFT JOIN students s
    ON s.department_id = d.id
GROUP BY d.name
ORDER BY total_students DESC;


-- 11. Average grade per course
-- (Assumes 'grade' column exists in enrollments)
SELECT
    c.name AS course_name,
    ROUND(AVG(e.grade), 2) AS average_grade
FROM courses c
JOIN enrollments e
    ON e.course_id = c.id
WHERE e.grade IS NOT NULL
GROUP BY c.name
ORDER BY average_grade DESC;


-- 12. Department-wise course performance
SELECT
    d.name AS department_name,
    c.name AS course_name,
    ROUND(AVG(e.grade), 2) AS average_grade,
    COUNT(e.id) AS total_enrollments
FROM departments d
JOIN students s
    ON s.department_id = d.id
JOIN enrollments e
    ON e.student_id = s.id
JOIN courses c
    ON c.id = e.course_id
WHERE e.grade IS NOT NULL
GROUP BY d.name, c.name
ORDER BY d.name, average_grade DESC;
