-- ===============================
-- Seed data for testing schema
-- ===============================

-- Departments
INSERT INTO departments (name, head) VALUES
('Computer Science', 'Dr. Mehta'),
('Electrical Engineering', 'Dr. Rao')
ON CONFLICT (name) DO NOTHING;

-- Students
INSERT INTO students (name, email, phone, year) VALUES
('Alice Sharma', 'alice.sharma@example.com', '9876543210', 2),
('Rahul Verma', 'rahul.verma@example.com', '9123456789', 3),
('Neha Singh', 'neha.singh@example.com', NULL, 1)
ON CONFLICT (email) DO NOTHING;

-- Courses
INSERT INTO courses (name, department_id, credits) VALUES
(
  'Data Structures',
  (SELECT id FROM departments WHERE name = 'Computer Science' LIMIT 1),
  4
),
(
  'Database Systems',
  (SELECT id FROM departments WHERE name = 'Computer Science' LIMIT 1),
  3
),
(
  'Circuits 101',
  (SELECT id FROM departments WHERE name = 'Electrical Engineering' LIMIT 1),
  3
);

-- Enrollments
INSERT INTO enrollments (student_id, course_id, grade) VALUES
(
  (SELECT id FROM students WHERE email = 'alice.sharma@example.com' LIMIT 1),
  (SELECT id FROM courses WHERE name = 'Data Structures' LIMIT 1),
  8.5
),
(
  (SELECT id FROM students WHERE email = 'rahul.verma@example.com' LIMIT 1),
  (SELECT id FROM courses WHERE name = 'Database Systems' LIMIT 1),
  7.8
),
(
  (SELECT id FROM students WHERE email = 'neha.singh@example.com' LIMIT 1),
  (SELECT id FROM courses WHERE name = 'Circuits 101' LIMIT 1),
  9.1
)
ON CONFLICT (student_id, course_id) DO NOTHING;
