Activity 1
CREATE TABLE Student(
    Student_ID NUMBER PRIMARY KEY,
    First_Name VARCHAR2(30),
    Last_Name VARCHAR2(30) NOT NULL,
    Email VARCHAR2(60) UNIQUE,
    Enroll_Date DATE NOT NULL,
    Fees NUMBER(8,2) DEFAULT 0
    );
    
Activity 2&3
CREATE TABLE Department(
    Dept_ID NUMBER PRIMARY KEY,
    Dept_NAME VARCHAR(50) UNIQUE NOT NULL,
    Location VARCHAR2(50)
    );
    
ALTER TABLE Student
ADD Dept_ID NUMBER REFERENCES Department(Dept_ID);

Activity 4
ALTER TABLE Student
ADD (
    phone  VARCHAR2(20),
    status VARCHAR2(10) DEFAULT 'ACTIVE'
);

ALTER TABLE Student
MODIFY phone VARCHAR2(30);

ALTER TABLE Student
DROP COLUMN status;

ALTER TABLE students
SET UNUSED (phone);

ALTER TABLE students
DROP UNUSED COLUMNS;

CREATE TABLE students_archive
AS SELECT * FROM students WHERE 1 = 0;

RENAME students_archive TO students_old;

Section 2&3
ALTER TABLE Student
ADD CONSTRAINT check_fees CHECK (fees >= 0);

ALTER TABLE Student
ADD CONSTRAINT email_unique UNIQUE (email)
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE students
DISABLE CONSTRAINT check_fees;

ALTER TABLE students
ENABLE CONSTRAINT check_fees;

ALTER TABLE students
DROP CONSTRAINT email_unique;

Section 3
INSERT INTO Department VALUES (10, 'IT', 'Building A');
INSERT INTO Department VALUES (20, 'HR', 'Building B');
INSERT INTO Department VALUES (30, 'Computer Science', 'Building C');

INSERT INTO Student (student_id, first_name, last_name, email, enroll_date, fees, dept_id)
VALUES (1, 'John', 'Smith', 'john.smith@mail.com', SYSDATE, 1500, 10);

INSERT INTO Student VALUES (2, 'Mary', 'Jane', 'mary.janebleing@mail.com', SYSDATE, 2000, 20);
INSERT INTO Student VALUES (3, 'Peter', 'Mama', 'peter.mama@mail.com', SYSDATE, 500, 10);
INSERT INTO Student VALUES (4, 'Lerato', 'Molefe', 'lerato.m@mail.com', SYSDATE, 3000, 30);
INSERT INTO Student VALUES (5, 'Sam', 'Miller', 'sam.m@mail.com', SYSDATE, 800, 10);

UPDATE students
SET fees = fees * 1.10;

DELETE FROM students
WHERE status = 'INACTIVE';

UPDATE students
SET dept_id = 30
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'IT');

SELECT 
    first_name || ' ' || last_name AS full_name,
    d.dept_name,
    enroll_date
FROM students s
JOIN departments d ON s.dept_id = d.dept_id;

SELECT * FROM students
WHERE fees > 1000;

SELECT * FROM students
ORDER BY last_name;

SELECT s.*, d.dept_name
FROM students s
INNER JOIN departments d
ON s.dept_id = d.dept_id;

SELECT d.dept_name, COUNT(*) AS student_count
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
GROUP BY d.dept_name;

SELECT 
    SUM(fees) AS total_fees,
    AVG(fees) AS avg_fees,
    MAX(fees) AS highest_fees,
    MIN(fees) AS lowest_fees
FROM students;

SELECT * FROM students
WHERE last_name LIKE 'M%';

SELECT * FROM students
WHERE enroll_date BETWEEN :start_date AND :end_date;

SELECT * FROM students
WHERE dept_id IN (10, 20, 30);

SELECT DISTINCT dept_id
FROM students;

SELECT *
FROM students
WHERE fees > (SELECT AVG(fees) FROM students);

SELECT *
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM students s
    WHERE s.dept_id = d.dept_id
);

SELECT dept_name FROM departments
UNION
SELECT last_name FROM students;

SELECT 
    first_name,
    last_name,
    fees,
    CASE 
        WHEN fees > 5000 THEN 'HIGH'
        WHEN fees BETWEEN 2000 AND 5000 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS fee_level
FROM students;

SELECT d.dept_name, COUNT(*) AS student_count
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(*) > 3;

CREATE SEQUENCE seq_students
START WITH 1000
INCREMENT BY 1;

CREATE INDEX idx_students_lastname
ON students(last_name);

CREATE VIEW vw_student_details AS
SELECT 
    first_name || ' ' || last_name AS full_name,
    d.dept_name,
    fees
FROM students s
JOIN departments d ON s.dept_id = d.dept_id;

SELECT *
FROM (
    SELECT first_name, last_name, fees
    FROM students
    ORDER BY fees DESC
)
WHERE ROWNUM <= 3;

DROP VIEW vw_student_details;