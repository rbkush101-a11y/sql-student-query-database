-- CRUD DEMONSTRATION (CREATE, READ, UPDATE, DELETE)
-- All changes happen inside a transaction and are ROLLED BACK at the end.
-- This lets you practice safely without permanently changing demo rows.
USE student_query_management;

START TRANSACTION;

-- CREATE: add a demo student.
INSERT INTO students (student_name, mobile_number, email, city, enquiry_date)
VALUES ('Demo Student', '9000000099', 'demo@example.com', 'Prayagraj', CURRENT_DATE);
SET @demo_student_id = LAST_INSERT_ID();

-- CREATE: the same student enquires about CCC Course (course_id 1).
INSERT INTO enquiries
(student_id, course_id, enquiry_source, admission_status, follow_up_date, remarks)
VALUES
(@demo_student_id, 1, 'Website', 'Interested', CURRENT_DATE, 'Transaction practice');
SET @demo_enquiry_id = LAST_INSERT_ID();

-- READ: inspect the newly inserted enquiry.
SELECT e.enquiry_id, s.student_name, c.course_name, e.admission_status
FROM enquiries AS e
JOIN students AS s ON s.student_id = e.student_id
JOIN courses AS c ON c.course_id = e.course_id
WHERE e.enquiry_id = @demo_enquiry_id;

-- UPDATE: contact the lead and schedule a follow-up in 2 days.
UPDATE enquiries
SET admission_status = 'Follow Up',
    follow_up_date = DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY),
    remarks = 'Contacted: follow-up planned'
WHERE enquiry_id = @demo_enquiry_id;

-- READ: confirm the updated values.
SELECT enquiry_id, admission_status, follow_up_date, remarks
FROM enquiries
WHERE enquiry_id = @demo_enquiry_id;

-- DELETE: child (enquiry) before parent (student), respecting FKs.
DELETE FROM enquiries WHERE enquiry_id = @demo_enquiry_id;
DELETE FROM students WHERE student_id = @demo_student_id;

-- Restore everything to its state before START TRANSACTION.
ROLLBACK;

-- Check that the practice student is not present.
SELECT COUNT(*) AS remaining_demo_students
FROM students WHERE mobile_number = '9000000099';
