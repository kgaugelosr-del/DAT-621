CREATE TABLE STUDENTS (
    student_idD NUMBER PRIMARY KEY,
    first_name VARCHAR2(30),
    last_name VARCHAR2(30) NOT NULL,
    email VARCHAR2(60) UNIQUE,
    enroll_date DATE NOT NULL,
    fees NUMBER(8,2) DEFAULT 0
);
--(ex1)--

CREATE TABLE DEPARTMENTS (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2 (50) UNIQUE NOT NULL,
    location VARCHAR2 (50)
);
--(ex2)--

ALTER TABLE STUDENTS
ADD dept_id NUMBER;

ALTER TABLE STUDENTS
ADD CONSTRAINT fk_dept
FOREIGN KEY (dept_id)
REFERENCES DEPARTMENTS(dept_id);
--(ex3)--

ALTER TABLE STUDENTS
ADD phone VARCHAR2(20);

ALTER TABLE STUDENTS
ADD status VARCHAR2(10) DEFAULT 'ACTIVE';
--(ex4)--

ALTER TABLE STUDENTS
MODIFY phone VARCHAR2(30);
 --(ex5)--
 
ALTER TABLE STUDENTS
DROP COLUMN status;
 --(ex6)--

ALTER TABLE STUDENTS
SET UNUSED (phone);
 --(ex7)--

ALTER TABLE STUDENTS
DROP UNUSED COLUMNS;
 --(ex8)--

CREATE TABLE STUDENTS_ARCHIVE
    AS SELECT * FROM STUDENTS
    WHERE 1 = 0;
 --(ex9)--

RENAME STUDENTS_ARCHIVE TO STUDENTS_OLD;
 --(ex10)--

ALTER TABLE STUDENTS
ADD CONSTRAINT check_fees
CHECK (fees > = 0);
 --(ex11)--

ALTER TABLE STUDENTS
ADD CONSTRAINT unqiue_email
UNIQUE (email)
DEFERRABLE INITIALLY DEFERRED;
 --(ex12)--
 
ALTER TABLE STUDENTS
DISABLE CONSTRAINT check_fees;
 --(ex13)--

ALTER TABLE STUDENTS
ENABLE CONSTRAINT check_fees;
 --(ex14)--

ALTER TABLE STUDENTS
DROP CONSTRAINT unqiue_email;
 --(ex15)--

INSERT INTO DEPARTMENTS VALUES (10, 'IT', 'Building A');
INSERT INTO DEPARTMENTS VALUES (20, 'COMPUTER SCIENCE', 'Building B');
 --(ex16)--

INSERT INTO STUDENTS VALUES (1,'Moshega','Lebea','lebeam@gmail.com',DATE '2024-01-10',1500,10);
INSERT INTO STUDENTS VALUES (2,'Maximillian','Mohale','maxmohale@gmail.com',DATE '2024-02-15',2000,20);
INSERT INTO STUDENTS VALUES (3,'Gift','digmomo','giftd@gmail.com',DATE '2024-03-01',1200,10);
INSERT INTO STUDENTS VALUES (4,'Ketso','Setoba','sebobaketso@gmail.com',DATE '2024-01-20',3000,30);
INSERT INTO STUDENTS VALUES (5,'Shannia','Mlhari','shanniamhlari@gmail.com',DATE '2024-04-10',2500,20);
 --(ex17)--

UPDATE STUDENTS
SET fess = fees * 1.10;
 --(ex18)--
 
DELETE FROM STUDENTS
WHERE status = 'INACTIVE';
 --(ex19)--
 
UPDATE STUDENTS
SET dept_id =
(
    SELECT dept_id
    FROM DEPARTMENTS
    WHERE dept_name = 'COMPUTER SCIENCE'
)
WHERE DEPT_ID =
(
    SELECT dept_id
    FROM DEPARTMENTS
    WHERE dept_name = 'IT'
);
 --(ex20)--
 
SELECT first_name || ' ' || last_name AS full_name,
       dept_name,
       enroll_date
FROM STUDENTS
JOIN DEPARTMENTS
ON STUDENTS.dept_id = DEPARTMENTS.dept_id;
 --(ex21)--

SELECT *
    FROM STUDENTS
    WHERE fees > 1000;
 --(ex22)--
 
SELECT *
    FROM STUDENTS
    ORDER BY last_name;
--(ex23)--
 
SELECT first_name, last_name, dept_name
    FROM STUDENTS
    INNER JOIN DEPARTMENTS
ON STUDENTS.dept_id = DEPARTMENTS.dept_id;
--(ex24)--

SELECT dept_name, COUNT(*) AS STUDENT_COUNT
    FROM STUDENTS
    JOIN DEPARTMENTS
ON STUDENTS.dept_id = DEPARTMENTS.dept_id
GROUP BY dept_name;
 --(ex25)--
 
SELECT
SUM(fees) AS total_fees,
AVG(fees) AS avg_fees,
MAX(fees) AS highest_fees,
MIN(fees) AS lowest_fees
FROM STUDENTS;
 --(ex26)--
 
SELECT *
    FROM STUDENTS
    WHERE last_name LIKE 'M%';
--(ex27)--
 
SELECT *
    FROM STUDENTS
    WHERE enroll_date BETWEEN DATE '2024-01-01' AND DATE '2024-12-31';
--(ex28)--

SELECT *
    FROM STUDENTS
    WHERE dept_id IN (10,20,30);
 --(ex29)--

SELECT DISTINCT dept_id
FROM STUDENTS;
 --(ex30)--
 
SELECT *
    FROM STUDENTS
    WHERE fees >
(
SELECT AVG(fees)
    FROM STUDENTS
);
 --(ex31)--
 
SELECT *
    FROM DEPARTMENTS D
    WHERE NOT EXISTS
(
SELECT *
    FROM STUDENTS S
    WHERE S.dept_id = D.dept_id
);
 --(ex32)--
 
SELECT dept_name
    FROM DEPARTMENTS
UNION
SELECT last_name
    FROM STUDENTS;
 --(ex33)--
 
SELECT first_name, last_name, fees,
CASE
    WHEN fees > 5000 THEN 'HIGH'
    WHEN fees BETWEEN 2000 AND 5000 THEN 'MEDIUM'
ELSE 'LOW'
    END AS FEE_CATEGORY
FROM STUDENTS;
--(ex34)--

SELECT dept_id, 
    COUNT(*) AS TOTAL
    FROM STUDENTS
    GROUP BY dept_id
    HAVING COUNT(*) > 3;
 --(ex35)--
 
CREATE SEQUENCE SEQ_STUDENTS
START WITH 1000
INCREMENT BY 1;
 --(ex36)--
 
CREATE INDEX IDX_LASTNAME
ON STUDENTS(last_name);
 --(ex37)--
 
CREATE VIEW VW_STUDENT_DETAILS AS
    SELECT FIRST_NAME || ' ' || last_name AS full_name,
       dept_name,
       fees
    FROM STUDENTS
    JOIN DEPARTMENTS
    ON STUDENTS.dept_id = DEPARTMENTS.dept_id;
--(ex38)--

SELECT * FROM (
    SELECT first_name, last_name, fees
    FROM STUDENTS
    ORDER BY fees DESC )
    WHERE ROWNUM <= 3;
 --(ex39)--
 
DROP VIEW VW_STUDENT_DETAILS;
 --(ex40)--
