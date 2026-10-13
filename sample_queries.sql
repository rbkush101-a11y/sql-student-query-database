-- REPORTING QUERIES
-- Run student_query_database.sql first, then run this file in MySQL Workbench
-- or: mysql -u root -p student_query_management < sample_queries.sql
USE student_query_management;

-- Q1: All enquiries (one student may enquire about several courses).
SELECT e.enquiry_id, s.student_name, s.mobile_number, c.course_name,
       e.enquiry_source, e.admission_status, e.follow_up_date
FROM enquiries AS e
INNER JOIN students AS s ON s.student_id = e.student_id
INNER JOIN courses AS c ON c.course_id = e.course_id
ORDER BY e.enquiry_id;

-- Q2: Students who are interested in courses.
SELECT s.student_name, s.mobile_number, c.course_name, e.remarks
FROM enquiries AS e
INNER JOIN students AS s ON s.student_id = e.student_id
INNER JOIN courses AS c ON c.course_id = e.course_id
WHERE e.admission_status = 'Interested'
ORDER BY s.student_name;

-- Q3: Enquiries per course. LEFT JOIN also returns courses with 0 enquiries.
SELECT c.course_name, COUNT(e.enquiry_id) AS total_enquiries
FROM courses AS c
LEFT JOIN enquiries AS e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_enquiries DESC, c.course_name;

-- Q4: Students with a demo booked.
SELECT s.student_name, s.mobile_number, c.course_name,
       e.follow_up_date AS demo_or_followup_date
FROM enquiries AS e
JOIN students AS s ON s.student_id = e.student_id
JOIN courses AS c ON c.course_id = e.course_id
WHERE e.admission_status = 'Demo Booked'
ORDER BY e.follow_up_date;

-- Q5: Follow-ups scheduled today (not closed/won or lost).
SELECT s.student_name, c.course_name, e.admission_status, e.follow_up_date
FROM enquiries AS e
JOIN students AS s ON s.student_id = e.student_id
JOIN courses AS c ON c.course_id = e.course_id
WHERE e.admission_status IN ('Interested', 'Follow Up', 'Demo Booked')
  AND e.follow_up_date = CURRENT_DATE
ORDER BY s.student_name;

-- Q6: Overdue follow-ups: a past date and a still-active enquiry.
SELECT s.student_name, c.course_name, e.admission_status,
       e.follow_up_date, DATEDIFF(CURRENT_DATE, e.follow_up_date) AS days_overdue
FROM enquiries AS e
JOIN students AS s ON s.student_id = e.student_id
JOIN courses AS c ON c.course_id = e.course_id
WHERE e.admission_status IN ('Interested', 'Follow Up', 'Demo Booked')
  AND e.follow_up_date < CURRENT_DATE
ORDER BY e.follow_up_date;

-- Q7: Upcoming follow-ups (not including today).
SELECT s.student_name, c.course_name, e.follow_up_date
FROM enquiries AS e
JOIN students AS s ON s.student_id = e.student_id
JOIN courses AS c ON c.course_id = e.course_id
WHERE e.admission_status IN ('Interested', 'Follow Up', 'Demo Booked')
  AND e.follow_up_date > CURRENT_DATE
ORDER BY e.follow_up_date;

-- Q8: Number of enquiries by status.
SELECT e.admission_status, COUNT(*) AS total_enquiries
FROM enquiries AS e
GROUP BY e.admission_status
ORDER BY total_enquiries DESC, e.admission_status;

-- Q9: Total enquiries and admitted enquiries by source.
SELECT e.enquiry_source,
       COUNT(*) AS total_enquiries,
       SUM(CASE WHEN e.admission_status = 'Admitted' THEN 1 ELSE 0 END) AS admitted_enquiries
FROM enquiries AS e
GROUP BY e.enquiry_source
ORDER BY total_enquiries DESC, e.enquiry_source;

-- Q10: Students who have enquired about more than one course.
SELECT s.student_name, COUNT(DISTINCT e.course_id) AS distinct_courses
FROM students AS s
JOIN enquiries AS e ON e.student_id = s.student_id
GROUP BY s.student_id, s.student_name
HAVING COUNT(DISTINCT e.course_id) > 1
ORDER BY distinct_courses DESC;

-- Q11: Daily enquiry count by first-contact date.
-- This uses students.enquiry_date, not enquiries.created_at; it therefore
-- counts first contacts, not individual enquiry rows.
SELECT s.enquiry_date, COUNT(*) AS new_students
FROM students AS s
GROUP BY s.enquiry_date
ORDER BY s.enquiry_date;


-- Q12: Active enquiries with missing follow-up dates.
SELECT
    s.student_name,
    c.course_name,
    e.admission_status,
    e.follow_up_date
FROM enquiries AS e
INNER JOIN students AS s
    ON e.student_id = s.student_id
INNER JOIN courses AS c
    ON e.course_id = c.course_id
WHERE e.admission_status IN (
    'Interested',
    'Follow Up',
    'Demo Booked'
)
AND e.follow_up_date IS NULL
ORDER BY s.student_name;


-- Q13: Complete follow-up status report.
SELECT
    s.student_name,
    c.course_name,
    e.admission_status,
    e.follow_up_date,
    CASE
        WHEN e.follow_up_date IS NULL
            THEN 'Missing Date'
        WHEN e.follow_up_date < CURDATE()
            THEN 'Overdue'
        WHEN e.follow_up_date = CURDATE()
            THEN 'Due Today'
        ELSE 'Upcoming'
    END AS follow_up_category
FROM enquiries AS e
INNER JOIN students AS s
    ON e.student_id = s.student_id
INNER JOIN courses AS c
    ON e.course_id = c.course_id
WHERE e.admission_status IN (
    'Interested',
    'Follow Up',
    'Demo Booked'
)
ORDER BY e.follow_up_date ASC;
