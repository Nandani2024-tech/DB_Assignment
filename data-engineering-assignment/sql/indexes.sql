-- =====================================================
-- INDEXES FOR QUERY OPTIMIZATION
-- =====================================================

-- 1. Speed up student lookup & deduplication
CREATE INDEX IF NOT EXISTS idx_students_email
ON students(email);


-- 2. Speed up joins between students and departments
CREATE INDEX IF NOT EXISTS idx_students_department_id
ON students(department_id);


-- 3. Speed up enrollment joins (student ↔ enrollment)
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id
ON enrollments(student_id);


-- 4. Speed up enrollment joins (course ↔ enrollment)
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id
ON enrollments(course_id);


-- 5. Speed up course name lookups
CREATE INDEX IF NOT EXISTS idx_courses_name
ON courses(name);


-- 6. Speed up department name lookups
CREATE INDEX IF NOT EXISTS idx_departments_name
ON departments(name);
