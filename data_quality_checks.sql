
-- =====================================================
-- STUDENT QUERY MANAGEMENT DATABASE
-- DATA QUALITY AUDIT QUERIES
-- =====================================================
-- Purpose:
-- Detect missing, duplicate, invalid and inconsistent
-- student and enquiry data.
--
-- Run after student_query_database.sql.
-- All queries are read-only.
-- =====================================================

USE student_query_management;


-- QA1: Active enquiries with missing follow-up dates

SELECT
    e.enquiry_id,
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
AND e.follow_up_date IS NULL;


-- QA2: Missing student email addresses

SELECT
    student_id,
    student_name,
    mobile_number,
    email
FROM students
WHERE email IS NULL
   OR TRIM(email) = '';


-- QA3: Duplicate mobile number detection
-- Same number does not always mean duplicate student.

SELECT
    TRIM(mobile_number) AS mobile,
    COUNT(*) AS duplicate_count
FROM students
WHERE mobile_number IS NOT NULL
  AND TRIM(mobile_number) <> ''
GROUP BY TRIM(mobile_number)
HAVING COUNT(*) > 1;


-- QA4: Repeated enquiries for the same course
-- These may be genuine re-enquiries.

SELECT
    s.student_name,
    c.course_name,
    COUNT(*) AS enquiry_count
FROM enquiries AS e
INNER JOIN students AS s
    ON e.student_id = s.student_id
INNER JOIN courses AS c
    ON e.course_id = c.course_id
GROUP BY
    e.student_id,
    e.course_id,
    s.student_name,
    c.course_name
HAVING COUNT(*) > 1;


-- QA5: Foreign key reference validation

SELECT
    e.enquiry_id,
    e.student_id,
    e.course_id
FROM enquiries AS e
LEFT JOIN students AS s
    ON e.student_id = s.student_id
LEFT JOIN courses AS c
    ON e.course_id = c.course_id
WHERE s.student_id IS NULL
   OR c.course_id IS NULL;


-- QA6: Invalid Indian mobile number format
-- Valid format: 10 digits, starts with 6, 7, 8 or 9.

SELECT
    student_id,
    student_name,
    mobile_number
FROM students
WHERE mobile_number IS NULL
   OR TRIM(mobile_number)
      NOT REGEXP '^[6-9][0-9]{9}$';


-- QA7: Complete Data Quality Audit Summary

SELECT

    (SELECT COUNT(*)
     FROM students) AS total_students,

    (SELECT COUNT(*)
     FROM courses) AS total_courses,

    (SELECT COUNT(*)
     FROM enquiries) AS total_enquiries,

    (SELECT COUNT(*)
     FROM students
     WHERE email IS NULL
        OR TRIM(email) = '')
        AS missing_emails,

    (SELECT COUNT(*)
     FROM students
     WHERE mobile_number IS NULL
        OR TRIM(mobile_number)
           NOT REGEXP '^[6-9][0-9]{9}$')
        AS invalid_mobile_numbers,

    (SELECT COUNT(*)
     FROM (
         SELECT TRIM(mobile_number)
         FROM students
         WHERE mobile_number IS NOT NULL
           AND TRIM(mobile_number) <> ''
         GROUP BY TRIM(mobile_number)
         HAVING COUNT(*) > 1
     ) AS duplicate_groups)
        AS duplicate_mobile_groups,

    (SELECT COUNT(*)
     FROM enquiries
     WHERE admission_status IN (
         'Interested',
         'Follow Up',
         'Demo Booked'
     )
     AND follow_up_date IS NULL)
        AS missing_followup_dates;
