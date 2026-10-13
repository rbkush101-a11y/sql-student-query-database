# Student Query Management Database

A beginner-friendly MySQL project for managing **student course enquiries, admission statuses and follow-up dates** at a coaching institute. This upgraded version builds on the original three-table SQL project.

**Author:** Rishabh Kushwaha  
**Technology:** MySQL 8.0.16+, SQL, MySQL Workbench or VS Code + MySQL client  
**Project type:** Database-only (no website/backend/API is included)

## What is included?

- `students`, `courses`, and `enquiries` with primary and foreign keys
- Sample fictional records with interested, follow-up, demo-booked, admitted and not-interested statuses
- Reports using `INNER JOIN`, `LEFT JOIN`, `GROUP BY`, `COUNT`, `HAVING`, `CASE`, `DATEDIFF`
- Today, overdue and upcoming follow-up reports
- Transaction-safe practice for `INSERT`, `SELECT`, `UPDATE`, `DELETE`
- Quality-audit queries for missing follow-ups, optional missing emails and possible duplicates
- Simple verification checks

## 1. Requirements

Install **MySQL Server 8.0.16 or later** and (optionally) **MySQL Workbench**. The `CHECK` constraints require MySQL 8.0.16+; MySQL 8.4 is also suitable. You must have a MySQL account with permission to create databases and tables.

> **Warning:** `student_query_database.sql` is a DEMO RESET SCRIPT: it drops and recreates the project's three tables. It deletes existing data **in those tables** if you run it again. Do not run it against important/live data.

## 2. Run in MySQL Workbench (Windows)

1. Start **MySQL Server** and open **MySQL Workbench**.
2. Connect to your local MySQL server.
3. Open `student_query_database.sql`, then execute **all** statements (lightning button / `Ctrl+Shift+Enter` in Workbench).
4. Refresh **Schemas**; you should see `student_query_management` and its three tables.
5. Open `verification_queries.sql` and execute all statements. All `passed` values should be `1`.
6. Open and execute `sample_queries.sql` to see reports.
7. Open and execute `data_quality_checks.sql` to see quality issues.
8. Execute `crud_examples.sql` for safe CRUD practice; it uses a transaction and ends with `ROLLBACK`.

## 3. Alternative: MySQL command-line

Open a terminal in this project folder and run:

```powershell
mysql -u root -p < student_query_database.sql
mysql -u root -p student_query_management < verification_queries.sql
mysql -u root -p student_query_management < sample_queries.sql
mysql -u root -p student_query_management < data_quality_checks.sql
mysql -u root -p student_query_management < crud_examples.sql
```

**Windows PowerShell note:** Depending on your PowerShell version, input redirection (`<`) may not work. Use the classic **Command Prompt (cmd.exe)** for those commands, or use Workbench. Never put your database password in a GitHub repository.

## 4. How the database is connected

```text
students (student_id PK) 1 ----< enquiries >---- 1 courses (course_id PK)
                                     |
                                 enquiry_id PK
```

- `students`: one row per student; `enquiry_date` is that student's **first-contact date** in this demo.
- `courses`: available training courses, duration and fees.
- `enquiries`: one row per student's enquiry about a particular course. A single student can have multiple enquiry rows for different courses.
- `FOREIGN KEY` prevents linking enquiries to nonexistent students/courses.
- `UNIQUE` on mobile numbers is a demo business rule, not a universal requirement for real institutes (shared family numbers can occur).

## 5. Original vs. upgraded

| Original | Upgraded |
|---|---|
| 3 tables with basic constraints | 3 tables with stronger constraints + useful indexes |
| 5 courses, 4 students, 4 enquiries | 6 courses, 8 students, 9 enquiries (fictional demo data) |
| Five basic reports | Eleven reports including today/overdue/upcoming |
| UPDATE/DELETE listed in README but no sample statements | Transaction-safe CRUD examples |
| Course counts use INNER JOIN | LEFT JOIN includes zero-enquiry courses |
| No audit queries | Separate data quality checks |
| No repeatable verification file | Eight verification checks |

## 6. Understanding key SQL

**Primary Key** uniquely identifies a record. **Foreign Key** links two tables and protects referential integrity.

```sql
SELECT s.student_name, c.course_name, e.admission_status
FROM enquiries e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;
```

`JOIN` brings related records from separate tables into one result. `WHERE` filters rows; `GROUP BY` groups rows before aggregation; `COUNT` counts rows. `LEFT JOIN` keeps courses that have **zero** enquiries.

```sql
SELECT c.course_name, COUNT(e.enquiry_id) AS total_enquiries
FROM courses c
LEFT JOIN enquiries e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name;
```

Important: use `COUNT(e.enquiry_id)` rather than `COUNT(*)` with `LEFT JOIN`, because a no-match course still creates one result row with NULL enquiry fields.

## 7. What to expect from the demo data

- 6 courses, 8 students, 9 enquiries
- **Tally Basics** has **0** enquiries, shown by `LEFT JOIN`
- **Kavya Sharma** has enquiries in both Typing and Python courses
- **Dev Mishra** has an active enquiry with no follow-up date; a QA query flags it
- Original July 2026 active follow-ups appear overdue when you run the script later than July 2026
- Newer example follow-ups include one today and two in the future (based on the day the seed file is executed)

## 8. Project limitations / next improvements

This is a **SQL learning project**, not a production admissions CRM. It has no app UI, login, audit log, scheduled reminder service, phone/email verification, or advanced duplicate resolution. `students.enquiry_date` means first-contact date, not per-enquiry creation date. Quality checks *identify possible problems*; they do not silently fix them. `admission_status` is a current snapshot, not a history of each status transition.

For a real institute, add users/roles, privacy controls, a follow-up activity history, dates on each enquiry, and a backend/API layer before using real student information.

## 9. Files

```text
student-query-management-complete/
├── student_query_database.sql  # schema + demo data; resets demo tables
├── sample_queries.sql         # 11 reporting queries
├── crud_examples.sql          # INSERT/SELECT/UPDATE/DELETE with ROLLBACK
├── data_quality_checks.sql    # QA audits
├── verification_queries.sql   # expected demo counts and integrity checks
├── INTERVIEW_PREP.md          # what to say about your work
├── HINGLISH_LEARNING_GUIDE.md # step-by-step SQL explanation
└── README.md                  # installation + full guide
```

## 10. Resume description (use after you understand and run it)

**Student Enquiry Management Database | MySQL, SQL**

- Designed a three-table relational database to track student profiles, courses and admission enquiries using primary/foreign keys.
- Wrote SQL reports with JOIN, LEFT JOIN, GROUP BY and COUNT to examine enquiry status and follow-up schedules.
- Added data-quality checks for missing follow-ups and potential duplicate enquiries, with transaction-safe CRUD examples.

Only claim hands-on implementation and testing after you have run and understood the scripts yourself.
