1️⃣ Short Header (Context)


Target Database Schema Context
Version: v1.0 (Frozen)
Source: Phase 0 – Database Design
Purpose: Provide authoritative schema reference for ETL mapping and validation rule generation.




2️⃣ Table-by-Table Schema Summary (CORE REQUIREMENT)


TABLE: departments
- id (PK, SERIAL)
- name (VARCHAR(100), UNIQUE, NOT NULL)
- head (VARCHAR(100), NULL)


TABLE: students
- id (PK, SERIAL)
- name (VARCHAR(100), NOT NULL)
- email (VARCHAR(150), UNIQUE, NOT NULL)
- phone (VARCHAR(20), NULL)
- year (INT, CHECK 1–5)
- department_id (FK → departments.id, NULLABLE)


TABLE: courses
- id (PK, SERIAL)
- name (VARCHAR(150), NOT NULL)
- department_id (FK → departments.id, NULLABLE)
- credits (INT, CHECK > 0)


TABLE: enrollments
- id (PK, SERIAL)
- student_id (FK → students.id)
- course_id (FK → courses.id)
- grade (NUMERIC(4,2), CHECK 0–10)
- enrolled_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- UNIQUE(student_id, course_id)




3️⃣ Business Keys Section (MANDATORY)
BUSINESS / NATURAL KEYS:
- departments: name
- students: email
- courses: (name, department_id)
- enrollments: (student_id, course_id)






4️⃣ Referential Integrity Rules (Short)
REFERENTIAL INTEGRITY:
- courses.department_id → departments.id (ON DELETE SET NULL)
- enrollments.student_id → students.id (ON DELETE CASCADE)
- enrollments.course_id → courses.id (ON DELETE CASCADE)






SCHEMA FREEZE CONFIRMATION:
- This schema is finalized and frozen for Phase 1
- ETL will conform strictly to this structure
- No new columns or tables may be introduced without a new schema version






SEMANTIC NOTES:
- students.year represents academic year (1 = first year, 5 = final year)
- enrollments.grade uses a 0–10 grading scale
- departments.name is case-insensitive for business uniqueness


