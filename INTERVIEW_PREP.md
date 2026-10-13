# SQL project – beginner learning notes and interview preparation

## Explain the project in 30 seconds

> I created a MySQL database for a coaching institute's student enquiries. It uses three related tables—students, courses, and enquiries. I link enquiries to the correct student and course using foreign keys. My SQL reports show students who are interested, upcoming and overdue follow-ups, and course-wise enquiry counts. I also practice data-quality checks such as finding missing follow-up dates. This is a database project, not a full-stack application.

*Use this only after reviewing the scripts and practising the queries yourself.*

## Key questions

**1. What is a table?** A structured set of records stored as rows and columns. `students` holds student details, `courses` holds course details, `enquiries` links them.

**2. What is a primary key?** A unique identifier for one row, such as `students.student_id`.

**3. What is a foreign key?** A field referencing another table's key. `enquiries.student_id` refers to `students.student_id`, keeping relationships valid.

**4. Why use three tables rather than one?** To reduce repeated student/course details and preserve a clear one-to-many relationship: one student may enquire about several courses.

**5. What is an INNER JOIN?** It returns related rows with matching keys on both sides, e.g. combine an enquiry with its student and course.

**6. What is a LEFT JOIN?** It keeps all rows from the left table, even if no matching enquiry exists. A course with zero enquiries is still reported.

**7. Why COUNT(e.enquiry_id) in LEFT JOIN?** `COUNT(*)` would count the no-match placeholder as one row. `COUNT(e.enquiry_id)` ignores NULL, correctly reporting zero.

**8. What is GROUP BY?** It collects rows into groups, such as course, so aggregate functions can count enquiries per course.

**9. What is HAVING?** It filters grouped results; in this project it finds students with enquiries about more than one course.

**10. What is CRUD?** Create (INSERT), Read (SELECT), Update (UPDATE), Delete (DELETE). `crud_examples.sql` demonstrates these inside a transaction.

**11. What is a transaction?** A unit of work that can be saved with `COMMIT` or undone with `ROLLBACK`. The demo uses `ROLLBACK` so practice changes do not remain.

**12. How is this relevant to data quality?** The audit queries flag active leads with missing follow-up dates, missing optional emails, potential repeat enquiries and invalid foreign-key references.

**13. Is this an AI data annotation project?** No. It demonstrates relational database, reporting and data-checking skills. A separate text-annotation QA project would demonstrate annotation directly.

## Practice in order

1. Run the seed script; show the three tables with `SELECT * FROM students;`, `SELECT * FROM courses;`, `SELECT * FROM enquiries;`.
2. Predict what `INNER JOIN` will display; then execute report Q1.
3. Execute Q3. Find **Tally Basics = 0**; change `LEFT JOIN` to `JOIN` temporarily and see how the course disappears.
4. Execute Q5, Q6 and Q7. Explain today vs overdue vs upcoming.
5. Execute QA1 and identify **Dev Mishra**'s missing follow-up date.
6. Execute `crud_examples.sql` and confirm the practice record has been rolled back.
7. Run `verification_queries.sql`; explain why each test has a result of `1`.

## Mini quiz (check yourself before viewing answers)

1. Which table stores `admission_status`?
2. Which key connects `enquiries` with `courses`?
3. Why does a course with no enquiries disappear from an INNER JOIN count?
4. How can you find a follow-up that is older than today?
5. Can a student's name appear more than once in the report? Why?

**Answers:** 1) `enquiries`. 2) `course_id`. 3) There is no matching enquiry row. 4) `WHERE follow_up_date < CURRENT_DATE` plus an active-status filter. 5) Yes; one student can enquire about multiple courses.
