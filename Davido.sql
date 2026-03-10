CREATE TABLE students (
Student_ID  NUMBER PRIMARY KEY,
First_Name varchar2 (30),
last_name varchar2 (30) not null,
email varchar2 (60) unique,
enroll_date date not null, 
fees number(8,2) default 0 );

select *FROM students;

create TABLE Departments (
dept_id NUMBER PRIMARY KEY,
dept_name varchar2(50) UNIQUE NOT NULL,
location VARCHAR2 (50));

INSERT INTO departments (dept_id, dept_name, location) VALUES (1, 'Human Resource', 'Pretoria');
INSERT INTO departments (dept_id, dept_name, location) VALUES (2, 'IT', 'Cape Town');
INSERT INTO departments (dept_id, dept_name, location) VALUES (3, 'Admin', 'Durban');

Select * from departments;


ALTER TABLE students add(
dept_id number) add CONSTRAINT fk_students_dep FOREIGN KEY (dept_id) REFERENCES Departments(dept_id);

Alter table students ADD( 
phone VARCHAR2(20),
status VARCHAR2(10) default 'active');

alter table students MODIFY( 
phone VARCHAR2(30));

alter table students drop(status);

alter table students set unused(phone);

alter table students drop UNUSED COLUMNS;

create table students_archive AS
SELECT * FROM  students 
where 1=0;

select * from students_old;

RENAME students_archive TO students_old;

alter TABLE students add CONSTRAINT ck_student_fees
check(fees>=0);

alter table students add CONSTRAINT uk_student_email
unique (email)
DEFERRABLE initially deferred;

ALTER TABLE students 
DROP CONSTRAINT SYS_C007093;

alter TABLE students DISABLE CONSTRAINT ck_student_fees;
alter table students disable CONSTRAINT uk_student_email;

insert into students (student_id,first_name,last_name,email,enroll_date,fees,dept_id)
values(1,'Davis','Mkhombo','davismkhombo@gmail.com',sysdate, 50000.00,1);
insert into students (student_id,first_name,last_name,email,enroll_date,fees,dept_id)
values(2,'Max','Dax','maxdax@gmail.com',sysdate, 50000.00,1);
insert into students (student_id,first_name,last_name,email,enroll_date,fees,dept_id)
values(3,'Letago','Mlambo','letgo@gmail.com',sysdate, 70000.00,2);
insert into students (student_id,first_name,last_name,email,enroll_date,fees,dept_id)
values(4,'Sam','Nkosi','nkosisam@gmail.com',sysdate, 70000.00,2);
insert into students (student_id,first_name,last_name,email,enroll_date,fees,dept_id)
values(5,'Amber','Ndoda','namber@gmail.com',sysdate, 25000.00,3);
insert into students (student_id,first_name,last_name,email,enroll_date,fees,dept_id)
values(6,'Tshepi','Murikami','tshepi@gmail.com',sysdate, 25000.00,3);

update students 
SET fees=fees * 1.10;

SELECT first_name, last_name, enroll_date, dept_name from students s  join departments d  on s.dept_id=d.dept_id;

SELECT s.first_name, s.last_name, d.dept_name
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id;

select d.dept_name, count (s.student_id) as student_count
from departments d
join students s ON d.dept_id = s.dept_id 
group by d.dept_name;

select sum(fees) as total_fees,
round (Avg(fees), 2) as average_fees,
max(fees) AS highest_fee,
min(fees) as lowest_fee from students;


select first_name, last_name
from students
where last_name LIKE '%M%';

select first_name, last_name from 
students 
where fees> (select avg(fees) from students);


create sequence seq_students
start with 1000 
INCREMENT by 1;

create index idx_student_lastname
ON students(last_name);


create view vw_students_details as 
select s.first_name, s.last_name, d.dept_name, s.fees
from students s 
join departments d on s.dept_id= d.dept_id;

SELECT *
FROM (SELECT first_name, last_name, fees 
      FROM students 
      ORDER BY fees DESC)
WHERE ROWNUM <= 3;

drop view vw_students_details;
