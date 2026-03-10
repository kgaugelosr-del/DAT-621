--Section 1--
CREATE TABLE Students2 (Student_ID NUMBER PRIMARY KEY,
                        First_Name VARCHAR2 (30),
                        Last_Name VARCHAR2 (30) NOT NULL,
                        Email VARCHAR2 (60) UNIQUE,
                        Enroll_Date DATE NOT NULL,
                        Fees NUMBER(8,2) DEFAULT 0
                        );
            
CREATE TABLE Departments (Dept_ID NUMBER PRIMARY KEY,
                         Dept_Name VARCHAR (50) UNIQUE NOT NULL,
                         Location VARCHAR2 (50)
                        );
                        
ALTER TABLE Students2
ADD Dept_ID NUMBER REFERENCES Departments (Dept_ID);

ALTER TABLE Students2
ADD (Phone VARCHAR2 (20),
    Status VARCHAR2 (10) DEFAULT 'ACTIVE'
    );
    
ALTER TABLE Students2
MODIFY Phone VARCHAR2 (30);

ALTER TABLE Students2
DROP COLUMN Status;

ALTER TABLE Students2
SET UNUSED COLUMN Phone;

ALTER TABLE Students2
DROP UNUSED COLUMNS;

CREATE TABLE Student_Archives
AS SELECT * FROM Students2
WHERE 1 = 0;

ALTER TABLE Student_Archives
RENAME TO Students_Old;

--Section 2--
ALTER TABLE Students2
ADD CONSTRAINT Student_Fees_CK CHECK (Fees >= 0);

ALTER TABLE Students2
ADD CONSTRAINT Students2_email_uq UNIQUE (Email)
    DEFERRABLE INITIALLY DEFERRED;
    
ALTER TABLE Students2
DISABLE CONSTRAINT Student_Fees_CK;

ALTER TABLE Students2
ENABLE CONSTRAINT Student_Fees_CK;

ALTER TABLE Students2
DROP CONSTRAINT Students2_email_uq;

--Section 3--
INSERT INTO Departments (Dept_ID, Dept_Name, Location) VALUES (10, 'COMPUTER SCIENCE', 'Class 2');
INSERT INTO Departments (Dept_ID, Dept_Name, Location) VALUES (20, 'IT', 'Class 11');
INSERT INTO Departments (Dept_ID, Dept_Name, Location) VALUES (30, 'MATHEMATICS', 'Class 6');

INSERT INTO Students2 (Student_ID, First_Name, Last_Name, Email, Enroll_Date, Fees, Dept_ID) VALUES (1, 'Alice', 'Martin', 'alice@ctucarreer.co.za', DATE '2023-09-01', 3500, 10);
INSERT INTO Students2 (Student_ID, First_Name, Last_Name, Email, Enroll_Date, Fees, Dept_ID) VALUES (2, 'Bob', 'Murphy', 'bob@ctucarreer.co.za', DATE '2023-09-01', 1200, 20);
INSERT INTO Students2 (Student_ID, First_Name, Last_Name, Email, Enroll_Date, Fees, Dept_ID) VALUES (3, 'Carol', 'Spider', 'carol@ctucarreer.co.za', DATE '2024-01-15', 6200, 10);
INSERT INTO Students2 (Student_ID, First_Name, Last_Name, Email, Enroll_Date, Fees, Dept_ID) VALUES (4, 'David', 'Bloom', 'david@ctucarreer.co.za', DATE '2024-01-15', 800, 30);
INSERT INTO Students2 (Student_ID, First_Name, Last_Name, Email, Enroll_Date, Fees, Dept_ID) VALUES (5, 'Emma', 'Minkus', 'emma@ctucarreer.co.za', DATE '2024-06-01', 4750, 20);

UPDATE Students2
SET Fees = Fees * 1.10;

DELETE FROM Students2
WHERE Status = 'INACTIVE';

UPDATE Students2
SET Dept_ID = (SELECT Dept_ID FROM Departments WHERE Dept_Name = 'COMPUTER SCIENCE')
WHERE Dept_ID = (SELECT Dept_ID FROM Departments WHERE Dept_Name = 'IT');

--Section 4--
SELECT s.First_Name || ' ' || s.Last_Name AS FULL_NAME,
       d.Dept_Name,
       s.Enroll_Date
FROM   Students2 s
JOIN   Departments d ON s.Dept_ID = d.Dept_ID;

SELECT Student_ID,
       First_Name || ' ' || Last_Name AS FULL_NAME,
       Fees
FROM   Students2
WHERE  Fees > 1000;

SELECT Student_ID,
       First_Name,
       Last_Name,
       Fees
FROM   Students2
ORDER BY Last_Name ASC;

SELECT s.Student_ID,
       s.First_Name || ' ' || s.Last_Name AS FULL_NAME,
       d.Dept_Name
FROM   Students2 s
INNER JOIN Departments d ON s.Dept_ID = d.Dept_ID;

SELECT d.Dept_Name,
       COUNT(s.Student_ID) AS NUM_STUDENTS
FROM   Departments d
LEFT JOIN Students2 s ON d.Dept_ID = s.Dept_ID
GROUP BY d.Dept_Name
ORDER BY NUM_STUDENTS DESC;

SELECT SUM(Fees) AS TOTAL_FEES,
       ROUND(AVG(Fees), 2) AS AVERAGE_FEES,
       MAX(Fees) AS HIGHEST_FEES,
       MIN(Fees) AS LOWEST_FEES
FROM Students2;

SELECT Student_ID,
       First_Name,
       Last_Name
FROM   Students2
WHERE  Last_Name LIKE 'M%';

SELECT Student_ID,
       First_Name || ' ' || Last_Name AS FULL_NAME,
       Enroll_Date
FROM   Students2
WHERE  Enroll_Date BETWEEN DATE '2023-01-01' AND DATE '2024-12-31';

SELECT s.Student_ID,
       s.First_Name || ' ' || Last_Name AS FULL_NAME,
       s.Dept_ID,
       d.Dept_Name
FROM   Students2 s
JOIN   Departments d ON s.Dept_ID = d.Dept_ID
WHERE  s.Dept_ID IN (10, 20, 30);

SELECT DISTINCT d.Dept_Name
FROM   Students2 s
JOIN   Departments d ON s.Dept_ID = d.Dept_ID
ORDER BY d.Dept_Name;

--Section 5--
SELECT Student_ID,
       First_Name || ' ' || Last_Name AS FULL_NAME,
       Fees
FROM   Students2
WHERE  Fees > (SELECT AVG(Fees) FROM Students2);

SELECT Dept_ID,
       Dept_Name
FROM   Departments d
WHERE  NOT EXISTS (
    SELECT 1
    FROM   Students2 s
    WHERE  s.Dept_ID = d.Dept_ID
);

SELECT Dept_Name AS NAME
FROM   Departments
UNION
SELECT Last_Name AS NAME
FROM   Students2
ORDER BY NAME;

SELECT Student_ID,
       First_Name || ' ' || Last_Name AS FULL_NAME,
       Fees,
       CASE
           WHEN Fees > 5000              THEN 'HIGH'
           WHEN Fees BETWEEN 2000 AND 5000 THEN 'MEDIUM'
           ELSE                               'LOW'
       END AS FEE_CATEGORY
FROM   Students2;

SELECT d.Dept_Name,
       COUNT(s.Student_ID) AS NUM_STUDENTS
FROM   Departments d
JOIN   Students2 s ON d.Dept_ID = s.Dept_ID
GROUP BY d.Dept_Name
HAVING COUNT(s.Student_ID) > 3;

--Section 6--
CREATE SEQUENCE SEQ_STUDENTS
    START WITH   1000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
CREATE INDEX idx_students_last_name
    ON Students2 (Last_Name);

CREATE OR REPLACE VIEW VW_STUDENT_DETAILS AS
    SELECT s.First_Name || ' ' || s.Last_Name AS FULL_NAME,
           d.Dept_Name,
           s.Fees
    FROM   Students2 s
    JOIN   Departments d ON s.Dept_ID = d.Dept_ID;
    
SELECT FULL_NAME,
       Dept_Name,
       Fees
FROM  ( SELECT s.First_Name || ' ' || s.Last_Name AS FULL_NAME,
           d.Dept_Name,
           s.Fees
    FROM   Students2 s
    JOIN   Departments d ON s.Dept_ID = d.Dept_ID
    ORDER BY s.Fees DESC )
WHERE ROWNUM <= 3;

DROP VIEW VW_STUDENT_DETAILS;