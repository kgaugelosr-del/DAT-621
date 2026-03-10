-- Section 1 --
-- Exercise 1 --
CREATE TABLE STUDENTS (
    student_id number primary key,
    first_name varchar2(30),
    last_name varchar2(30) not null,
    email varchar2(60) unique,
    enroll_date date not null,
    fees number(8,2) default 0
);

-- Exercise 2 --
CREATE TABLE DEPARTMENTS (
    dept_id number primary key,
    dept_name varchar2(50) unique not null,
    location varchar2(50)
);

-- Exercise 3 --
Alter TABLE STUDENTS
ADD dept_id number references departments(dept_id);

-- Exercise 4 --
ALTER TABLE STUDENTS
ADD phone varchar2(20)
ADD status varchar(10) default 'ACTIVE';

-- Exercise 5 --
ALTER TABLE STUDENTS
MODIFY (phone varchar2(30));

-- Exercise 6 --
ALTER TABLE STUDENTS
DROP COLUMN status;

-- Exercise 7 --
ALTER TABLE STUDENTS 
SET UNUSED (phone);

-- Exercise 8 --
ALTER TABLE STUDENTS
DROP UNUSED COLUMNS;

-- Exercise 9 --
CREATE TABLE STUDENT_ARCHIVE AS
SELECT * FROM STUDENTS;

-- Exercise 10 --
RENAME STUDENT_ARCHIVE TO STUDENTS_OLD;

-- Section 2 --
-- Exercise 11 --
ALTER TABLE STUDENTS
MODIFY (fees number(8,2) default 0 CHECK(fees>=0));

-- Exercise 12 --
ALTER TABLE students DROP CONSTRAINT SYS_C008365;

ALTER TABLE students ADD CONSTRAINT unq_email UNIQUE (email)
DEFERRABLE INITIALLY DEFERRED;

-- Exercise 13 --
ALTER TABLE students
DISABLE CONSTRAINT SYS_C008372;

-- Exercise 14 --
ALTER TABLE students
ENABLE CONSTRAINT SYS_C008372;

-- Exercise 15 --
ALTER TABLE students drop CONSTRAINT SYS_C008372;

-- Section 3 --
-- Exercise 16 --
INSERT ALL
    INTO departments(dept_id,dept_name,location) 
        VALUES(01, 'Accounting', 'Bloemfontain')
    INTO departments(dept_id,dept_name,location) 
        VALUES(02, 'IT', 'Pretoria')
    INTO departments(dept_id,dept_name,location) 
        VALUES(03, 'CyberSec', 'Boksburg')
SELECT * FROM dual;

-- Exercise 17 --
INSERT ALL
 INTO students VALUES (1, 'James',   'Wilson',   'james.wilson@email.com',   DATE '2023-09-01', 1500.00, 2)
 INTO students VALUES (2, 'Sarah',   'Johnson',  'sarah.johnson@email.com',  DATE '2023-09-01', 1750.00, 2)
 INTO students VALUES (3, 'Michael', 'Brown',    'michael.brown@email.com',  DATE '2024-01-15', 1500.00, 1)
 INTO students VALUES (4, 'Emily',   'Davis',    'emily.davis@email.com',    DATE '2024-01-15', 2000.00, 3)
 INTO students VALUES (5, 'Daniel',  'Martinez', 'daniel.martinez@email.com',DATE '2023-09-01', 1750.00, 3)
SELECT * FROM dual;

-- EXERCISE 18 --
UPDATE students
SET fees = fees * 1.10;

-- Exercise 19 --
DELETE FROM students
WHERE status = 'INACTIVE';

-- Exercise 20 --
UPDATE students
SET dept_id = (SELECT dept_id FROM departments
                WHERE dept_name = 'COMPUTER SCIENCE')
WHERE dept_id = (SELECT dept_id FROM departments
                 WHERE dept_name = 'IT');

-- Section 4 --

-- Exercise 21 --
SELECT s.first_name || ' ' || s.last_name AS full_name,
       d.dept_name,
       s.enroll_date
FROM   students s
JOIN   departments d ON s.dept_id = d.dept_id;

-- Exercise 22 --
SELECT * FROM students
WHERE fees > 1000;

-- Exercise 23 --
SELECT * FROM students
ORDER BY last_name ASC;

-- Exercise 24 --
SELECT s.first_name || ' ' || s.last_name AS full_name,
       d.dept_name
FROM   students s
INNER JOIN departments d ON s.dept_id = d.dept_id;

-- Exercise 25 --
SELECT d.dept_name,
       COUNT(s.student_id) AS num_students
FROM   departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- Exercise 26 --
SELECT SUM(fees)  AS total_fees,
       AVG(fees)  AS avg_fees,
       MAX(fees)  AS highest_fees,
       MIN(fees)  AS lowest_fees
FROM   students;

-- Exercise 27 --
SELECT * FROM students
WHERE last_name LIKE 'M%';

-- Exercise 28 --
SELECT * FROM students
WHERE enroll_date BETWEEN DATE '2023-01-01' AND DATE '2024-12-31';

-- Exercise 29 --
SELECT * FROM students
WHERE dept_id IN (1, 2, 3);

-- Exercise 30 --
SELECT DISTINCT d.dept_name
FROM   students s
JOIN   departments d ON s.dept_id = d.dept_id;

-- Section 5 --

-- Exercise 31 --
SELECT * FROM students
WHERE fees > (SELECT AVG(fees) FROM students);

-- Exercise 32 --
SELECT d.dept_name
FROM   departments d
WHERE  NOT EXISTS (
    SELECT 1 FROM students s
    WHERE s.dept_id = d.dept_id
);

-- Exercise 33 --
SELECT dept_name AS name FROM departments
UNION
SELECT last_name  AS name FROM students;

-- Exercise 34 --
SELECT first_name || ' ' || last_name AS full_name,
       fees,
       CASE
           WHEN fees > 5000               THEN 'HIGH'
           WHEN fees BETWEEN 2000 AND 5000 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS fee_category
FROM   students;

-- Exercise 35 --
SELECT d.dept_name, COUNT(s.student_id) AS num_students
FROM   departments d
JOIN   students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING COUNT(s.student_id) > 3;

-- Section 6 --

-- Exercise 36 --
CREATE SEQUENCE seq_students
    START WITH   1000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Exercise 37 --
CREATE INDEX idx_students_lastname
ON students(last_name);

-- Exercise 38 --
CREATE VIEW vw_student_details AS
    SELECT s.first_name || ' ' || s.last_name AS full_name,
           d.dept_name,
           s.fees
    FROM   students s
    JOIN   departments d ON s.dept_id = d.dept_id;

-- Exercise 39 --
SELECT *
FROM (
    SELECT first_name || ' ' || last_name AS full_name,
           fees
    FROM   students
    ORDER BY fees DESC
)
WHERE ROWNUM <= 3;

-- Exercise 40 --
DROP VIEW vw_student_details;

