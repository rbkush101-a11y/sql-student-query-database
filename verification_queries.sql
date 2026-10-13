-- EXPECTED OUTPUT TESTS: Run after the reset/seed script, BEFORE any
-- permanent edits. 1 = PASS and 0 = FAIL. All checks should be 1.
USE student_query_management;

SELECT 'Six courses seeded' AS test_name,
       (SELECT COUNT(*) FROM courses) = 6 AS passed
UNION ALL
SELECT 'Eight students seeded',
       (SELECT COUNT(*) FROM students) = 8
UNION ALL
SELECT 'Nine enquiries seeded',
       (SELECT COUNT(*) FROM enquiries) = 9
UNION ALL
SELECT 'Zero-enquiry course exists',
       (SELECT COUNT(*) FROM courses AS c LEFT JOIN enquiries AS e
          ON e.course_id = c.course_id
        WHERE e.enquiry_id IS NULL) = 1
UNION ALL
SELECT 'One missing active follow-up',
       (SELECT COUNT(*) FROM enquiries
         WHERE admission_status IN ('Interested', 'Follow Up', 'Demo Booked')
           AND follow_up_date IS NULL) = 1
UNION ALL
SELECT 'One admitted enquiry',
       (SELECT COUNT(*) FROM enquiries WHERE admission_status = 'Admitted') = 1
UNION ALL
SELECT 'One student enquires about two courses',
       (SELECT COUNT(*) FROM (
           SELECT student_id FROM enquiries
           GROUP BY student_id
           HAVING COUNT(DISTINCT course_id) > 1
        ) AS multiple_course_students) = 1
UNION ALL
SELECT 'No missing FK references',
       (SELECT COUNT(*) FROM enquiries AS e
        LEFT JOIN students AS s ON s.student_id = e.student_id
        LEFT JOIN courses AS c ON c.course_id = e.course_id
        WHERE s.student_id IS NULL OR c.course_id IS NULL) = 0;
