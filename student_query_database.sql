CREATE DATABASE student_query_management;

USE student_query_management;

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    duration_months INT,
    fees DECIMAL(10,2)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(15),
    email VARCHAR(100),
    city VARCHAR(50),
    enquiry_date DATE
);

CREATE TABLE enquiries (
    enquiry_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enquiry_source VARCHAR(50),
    admission_status VARCHAR(30),
    follow_up_date DATE,
    remarks VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO courses (course_name, duration_months, fees)
VALUES
('CCC Course', 3, 4500),
('O Level Course', 12, 12000),
('DCA Course', 6, 7000),
('Python Programming', 4, 8000),
('Typing Course', 3, 3000);

INSERT INTO students (student_name, mobile_number, email, city, enquiry_date)
VALUES
('Aman Singh', '9876543210', 'aman@gmail.com', 'Prayagraj', '2026-07-01'),
('Priya Verma', '9123456780', 'priya@gmail.com', 'Prayagraj', '2026-07-02'),
('Rahul Kumar', '9988776655', 'rahul@gmail.com', 'Jaunpur', '2026-07-03'),
('Neha Gupta', '9871234567', 'neha@gmail.com', 'Prayagraj', '2026-07-03');

INSERT INTO enquiries
(student_id, course_id, enquiry_source, admission_status, follow_up_date, remarks)
VALUES
(1, 1, 'WhatsApp', 'Interested', '2026-07-05', 'Asked about CCC batch timing'),
(2, 4, 'Instagram', 'Follow Up', '2026-07-06', 'Interested in Python classes'),
(3, 2, 'Phone Call', 'Not Interested', NULL, 'Currently not available'),
(4, 3, 'Google Form', 'Demo Booked', '2026-07-05', 'Demo class scheduled');