-- STUDENT QUERY MANAGEMENT DATABASE
-- Requirements: MySQL 8.0.16+ (CHECK constraints are enforced)
-- IMPORTANT: This is a DEMO RESET SCRIPT. Re-running it deletes rows from
-- the three project tables. Do not run it against production data.

CREATE DATABASE IF NOT EXISTS student_query_management
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE student_query_management;

-- Drop child table first because it references both parent tables.
DROP TABLE IF EXISTS enquiries;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

CREATE TABLE courses (
    course_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    duration_months INT NOT NULL,
    fees DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (course_id),
    CONSTRAINT uq_courses_name UNIQUE (course_name),
    CONSTRAINT chk_course_duration CHECK (duration_months > 0),
    CONSTRAINT chk_course_fees CHECK (fees >= 0)
) ENGINE=InnoDB;

CREATE TABLE students (
    student_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) NULL,
    city VARCHAR(50) NULL,
    enquiry_date DATE NOT NULL,
    PRIMARY KEY (student_id),
    CONSTRAINT uq_students_mobile UNIQUE (mobile_number)
) ENGINE=InnoDB;

CREATE TABLE enquiries (
    enquiry_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    student_id INT UNSIGNED NOT NULL,
    course_id INT UNSIGNED NOT NULL,
    enquiry_source VARCHAR(50) NOT NULL,
    admission_status ENUM(
        'Interested', 'Follow Up', 'Demo Booked', 'Admitted', 'Not Interested'
    ) NOT NULL DEFAULT 'Interested',
    follow_up_date DATE NULL,
    remarks VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (enquiry_id),
    CONSTRAINT fk_enquiries_student FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_enquiries_course FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_enquiries_status_followup (admission_status, follow_up_date),
    INDEX idx_enquiries_course (course_id)
) ENGINE=InnoDB;

-- These six fictional courses include one with zero enquiries so that
-- the LEFT JOIN report can demonstrate how zero-count courses appear.
INSERT INTO courses (course_name, duration_months, fees) VALUES
('CCC Course',          3,  4500.00),
('O Level Course',     12, 12000.00),
('DCA Course',          6,  7000.00),
('Python Programming',  4,  8000.00),
('Typing Course',       3,  3000.00),
('Tally Basics',        2,  4000.00);

-- The original four example students are retained. Additional fictional
-- students create practical cases for today's and future follow-ups.
INSERT INTO students
    (student_name, mobile_number, email, city, enquiry_date)
VALUES
('Aman Singh',   '9876543210', 'aman@gmail.com',     'Prayagraj', '2026-07-01'),
('Priya Verma',  '9123456780', 'priya@gmail.com',    'Prayagraj', '2026-07-02'),
('Rahul Kumar',  '9988776655', 'rahul@gmail.com',    'Jaunpur',   '2026-07-03'),
('Neha Gupta',   '9871234567', 'neha@gmail.com',     'Prayagraj', '2026-07-03'),
('Kavya Sharma','9000000005', 'kavya@example.com',  'Prayagraj', CURRENT_DATE),
('Irfan Ali',   '9000000006', 'irfan@example.com',  'Varanasi',  CURRENT_DATE),
('Simran Patel','9000000007', 'simran@example.com', 'Prayagraj', CURRENT_DATE),
('Dev Mishra',  '9000000008', NULL,                 'Jaunpur',   CURRENT_DATE);

-- The first four enquiries are retained from the original project.
-- Dates for newer examples are relative to today so that today's and
-- upcoming reports have useful demo results whenever the project is run.
INSERT INTO enquiries
    (student_id, course_id, enquiry_source, admission_status, follow_up_date, remarks)
VALUES
(1, 1, 'WhatsApp',    'Interested',     '2026-07-05', 'Asked about CCC batch timing'),
(2, 4, 'Instagram',   'Follow Up',      '2026-07-06', 'Interested in Python classes'),
(3, 2, 'Phone Call',  'Not Interested', NULL,         'Currently not available'),
(4, 3, 'Google Form', 'Demo Booked',    '2026-07-05', 'Demo class scheduled'),
(5, 5, 'Website',     'Interested',     CURRENT_DATE, 'Requested typing course details'),
(6, 2, 'Walk-in',     'Follow Up',      DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), 'Needs fee structure'),
(7, 3, 'Phone Call',  'Admitted',       NULL,         'Admission completed'),
(8, 4, 'WhatsApp',    'Interested',     NULL,         'Follow-up date not entered yet'),
(5, 4, 'Website',     'Follow Up',      DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), 'Also enquired about Python');
