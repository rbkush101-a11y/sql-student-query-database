-- View all student enquiries
SELECT 
    students.student_name,
    students.mobile_number,
    courses.course_name,
    enquiries.enquiry_source,
    enquiries.admission_status,
    enquiries.follow_up_date
FROM enquiries
JOIN students ON enquiries.student_id = students.student_id
JOIN courses ON enquiries.course_id = courses.course_id;

-- View interested students
SELECT 
    students.student_name,
    students.mobile_number,
    courses.course_name,
    enquiries.admission_status
FROM enquiries
JOIN students ON enquiries.student_id = students.student_id
JOIN courses ON enquiries.course_id = courses.course_id
WHERE enquiries.admission_status = 'Interested';

-- Course-wise enquiry count
SELECT 
    courses.course_name,
    COUNT(enquiries.enquiry_id) AS total_enquiries
FROM enquiries
JOIN courses ON enquiries.course_id = courses.course_id
GROUP BY courses.course_name;

-- View demo booked students
SELECT 
    students.student_name,
    students.mobile_number,
    courses.course_name,
    enquiries.follow_up_date
FROM enquiries
JOIN students ON enquiries.student_id = students.student_id
JOIN courses ON enquiries.course_id = courses.course_id
WHERE enquiries.admission_status = 'Demo Booked';

-- View follow-up students
SELECT 
    students.student_name,
    students.mobile_number,
    courses.course_name,
    enquiries.follow_up_date
FROM enquiries
JOIN students ON enquiries.student_id = students.student_id
JOIN courses ON enquiries.course_id = courses.course_id
WHERE enquiries.admission_status = 'Follow Up';