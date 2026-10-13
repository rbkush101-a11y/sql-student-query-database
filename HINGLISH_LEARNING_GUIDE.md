# Student Query Management Database — Hinglish Learning Guide

Is project ko **SQL ki practice** aur interview explanation ke liye use karo. Project ka goal coaching center mein student enquiries aur course selection ko track karna hai. Ye **backend database demo** hai, frontend website nahi.

## Lesson 1: Database, table, row, column

- **Database**: related information ka collection — `student_query_management`.
- **Table**: ek category ke records — `students`, `courses`, `enquiries`.
- **Row**: ek individual record — Aman Singh.
- **Column**: ek information field — `student_name`, `mobile_number`.

**Example**: `students` table mein Aman Singh ka student_id = 1 ho sakta hai. `courses` mein CCC Course ka course_id = 1 hai. `enquiries` row ke `student_id=1, course_id=1` hone se pata chalta hai ki Aman ne CCC course ke baare mein enquiry ki.

## Lesson 2: Tables mein kya store hota hai?

```text
students
  student_id (PK), student_name, mobile_number, email, city, enquiry_date

courses
  course_id (PK), course_name, duration_months, fees

enquiries
  enquiry_id (PK), student_id (FK), course_id (FK), enquiry_source,
  admission_status, follow_up_date, remarks, created_at
```

`students.enquiry_date` is demo mein student ki **first contact date** hai. `enquiries` mein separate course enquiries store hoti hain.

## Lesson 3: PRIMARY KEY vs FOREIGN KEY

- **Primary key**: har row ka unique ID, jaise `students.student_id`.
- **Foreign key**: doosri table ke record se link, jaise `enquiries.student_id`.
- FK rule ki wajah se aap aise student ke liye enquiry nahi bana sakte jo `students` table mein exist hi nahi karta.

## Lesson 4: Data types

- `INT`: whole number — course duration, student ID.
- `VARCHAR(100)`: text up to 100 characters — name.
- `DECIMAL(10,2)`: money, with two decimal digits — fee.
- `DATE`: date only — `follow_up_date`.
- `ENUM`: limited allowed values — admission status.
- `TIMESTAMP`: date and time — row creation timestamp.

## Lesson 5: CRUD ka matlab

| Operation | SQL | Real example |
|---|---|---|
| Create | `INSERT` | New student add karna |
| Read | `SELECT` | Student enquiries dekhna |
| Update | `UPDATE` | Interested se Follow Up status karna |
| Delete | `DELETE` | Demo record delete karna |

`crud_examples.sql` ko chalane par ye sab operations perform hote hain, lekin end mein `ROLLBACK` hone ki wajah se demo changes permanent nahi hote.

## Lesson 6: Simple SELECT + WHERE

```sql
USE student_query_management;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enquiries;

SELECT student_name, city
FROM students
WHERE city = 'Prayagraj';
```

`SELECT` batata hai kaunse columns chahiye. `FROM` batata hai kaunsi table. `WHERE` condition lagata hai.

## Lesson 7: JOIN kyon zaroori hai?

`enquiries` mein `student_id` aur `course_id` hain, lekin **student ka naam** `students` mein hai aur **course ka naam** `courses` mein. Dono naam lane ke liye tables JOIN karte hain:

```sql
SELECT s.student_name, c.course_name, e.admission_status
FROM enquiries AS e
JOIN students AS s ON e.student_id = s.student_id
JOIN courses AS c ON e.course_id = c.course_id;
```

Yahan `s`, `c`, `e` sirf short aliases hain.

## Lesson 8: INNER JOIN vs LEFT JOIN

`INNER JOIN` sirf matching records dikhata hai. `LEFT JOIN` left side ki **saari rows** dikhata hai, chahe matching enquiry na ho.

```sql
SELECT c.course_name, COUNT(e.enquiry_id) AS total_enquiries
FROM courses AS c
LEFT JOIN enquiries AS e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name;
```

Demo mein **Tally Basics = 0** aana chahiye. Agar `LEFT JOIN` ko `INNER JOIN` karoge, Tally Basics report se gayab ho jayega. `COUNT(e.enquiry_id)` NULL ko count nahi karta.

## Lesson 9: Follow-up query

```sql
SELECT enquiry_id, admission_status, follow_up_date
FROM enquiries
WHERE admission_status IN ('Interested', 'Follow Up', 'Demo Booked')
  AND follow_up_date < CURRENT_DATE;
```

- `< CURRENT_DATE` = date beet chuki, overdue.
- `= CURRENT_DATE` = aaj follow-up.
- `> CURRENT_DATE` = aage follow-up.
- `follow_up_date IS NULL` = date missing.
- Closed enquiries (`Admitted` / `Not Interested`) ko active follow-up report mein nahi liya gaya.

## Lesson 10: Data quality check

```sql
SELECT enquiry_id, student_id, admission_status
FROM enquiries
WHERE admission_status IN ('Interested', 'Follow Up', 'Demo Booked')
  AND follow_up_date IS NULL;
```

Isse **Dev Mishra** ka demo record milega: uski enquiry active hai, lekin follow-up date nahi di gayi. Is data ko review/fix karna chahiye. Ye ek basic quality analysis example hai.

## Lesson 11: Practice challenge

Ye queries pehle khud likho; phir `sample_queries.sql`/`data_quality_checks.sql` se compare karo.

1. `students` table ki saari rows dekho.
2. Sirf `city = 'Prayagraj'` ke students show karo.
3. Har course ke enquiries count karo, **zero** ko bhi show karo.
4. 'Interested' enquiries dikhao.
5. Aaj ke follow-ups dikhao.
6. Last month/previous day se pending follow-ups nikaalo.
7. Aise students dhoondo jinhone multiple courses ke liye enquiry ki.
8. Aise active enquiries dhundo jinke follow-up dates missing hain.

## Lesson 12: Interview mein kaise explain karna hai?

**Short answer (English):**

> I built a MySQL database for managing student enquiries at a coaching institute. It has three related tables for students, courses and enquiries. I used primary keys and foreign keys for data integrity, SQL joins for combined reports and data-quality checks to find missing follow-up dates.

**Honesty:** Is project ko full-stack web application mat batana. `AI annotation` directly implement nahi hui hai. Ye relational data management aur validation ki practice dikhata hai.

## Run order

1. `student_query_database.sql` (demo tables reset + seed)
2. `verification_queries.sql` (8 test rows, passed = 1)
3. `sample_queries.sql` (11 reports)
4. `data_quality_checks.sql` (6 QA reports)
5. `crud_examples.sql` (CRUD practice, safely rolled back)

**Warning:** First script demo data reset karta hai. Kisi real student database par execute mat karna.
