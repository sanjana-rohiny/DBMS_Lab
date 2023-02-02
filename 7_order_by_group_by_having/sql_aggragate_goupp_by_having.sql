create database lab7_expt;
use lab7_expt;
SET FOREIGN_KEY_CHECKS=0;


CREATE TABLE EMPLOYEE
( Fname           VARCHAR(10)   NOT NULL,
  Minit           CHAR,
  Lname           VARCHAR(20)      NOT NULL,
  Ssn             CHAR(9)          NOT NULL,
  Bdate           DATE,
  Address         VARCHAR(30),
  Sex             CHAR(1),
  Salary          DECIMAL(5),
  Super_ssn       CHAR(9),
  Dno             INT               NOT NULL,
PRIMARY KEY   (Ssn));

CREATE TABLE DEPARTMENT
( Dname           VARCHAR(15)       NOT NULL,
  Dnumber         INT               NOT NULL,
  Mgr_ssn         CHAR(9)           NOT NULL,
  Mgr_start_date  DATE,
PRIMARY KEY (Dnumber),
FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn) );

CREATE TABLE DEPT_LOCATIONS
( Dnumber         INT               NOT NULL,
  Dlocation       VARCHAR(15)       NOT NULL,
PRIMARY KEY (Dnumber, Dlocation),
FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber) );

CREATE TABLE PROJECT
( Pname           VARCHAR(15)       NOT NULL,
  Pnumber         INT               NOT NULL,
  Plocation       VARCHAR(15),
  Dnum            INT               NOT NULL,
PRIMARY KEY (Pnumber),
FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber) );

CREATE TABLE WORKS_ON
( Essn            CHAR(9)           NOT NULL,
  Pno             INT               NOT NULL,
  Hours           DECIMAL(3,1)      NOT NULL,
PRIMARY KEY (Essn, Pno),
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber) );

CREATE TABLE DEPENDENT
( Essn            CHAR(9)           NOT NULL,
  Dependent_name  VARCHAR(15)       NOT NULL,
  Sex             CHAR,
  Bdate           DATE,
  Relationship    VARCHAR(8),
PRIMARY KEY (Essn, Dependent_name),
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) );

INSERT INTO EMPLOYEE
VALUES      ('John','B','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5),
            ('Franklin','T','Wong',333445555,'1965-12-08','638 Voss, Houston TX','M',40000,888665555,5),
            ('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4),
            ('Jennifer','S','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4),
            ('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5),
            ('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5),
            ('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4),
            ('James','E','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,null,1);

INSERT INTO DEPARTMENT
VALUES      ('Research',5,333445555,'1988-05-22'),
            ('Administration',4,987654321,'1995-01-01'),
            ('Headquarters',1,888665555,'1981-06-19');

INSERT INTO PROJECT
VALUES      ('ProductX',1,'Bellaire',5),
            ('ProductY',2,'Sugarland',5),
            ('ProductZ',3,'Houston',5),
            ('Computerization',10,'Stafford',4),
            ('Reorganization',20,'Houston',1),
            ('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON
VALUES     (123456789,1,32.5),
           (123456789,2,7.5),
           (666884444,3,40.0),
           (453453453,1,20.0),
           (453453453,2,20.0),
           (333445555,2,10.0),
           (333445555,3,10.0),
           (333445555,10,10.0),
           (333445555,20,10.0),
           (999887777,30,30.0),
           (999887777,10,10.0),
           (987987987,10,35.0),
           (987987987,30,5.0),
           (987654321,30,20.0),
           (987654321,20,15.0),
           (888665555,20,16.0);

INSERT INTO DEPENDENT
VALUES      (333445555,'Alice','F','1986-04-04','Daughter'),
            (333445555,'Theodore','M','1983-10-25','Son'),
            (333445555,'Joy','F','1958-05-03','Spouse'),
            (987654321,'Abner','M','1942-02-28','Spouse'),
            (123456789,'Michael','M','1988-01-04','Son'),
            (123456789,'Alice','F','1988-12-30','Daughter'),
            (123456789,'Elizabeth','F','1967-05-05','Spouse');

INSERT INTO DEPT_LOCATIONS
VALUES      (1,'Houston'),
            (4,'Stafford'),
            (5,'Bellaire'),
            (5,'Sugarland'),
            (5,'Houston');
            
# 1)For each department, retrieve the department number, the number of employees in the department.
select Dno, count(*) 
from EMPLOYEE 
group by Dno;

# 2)For each department, retrieve the department name, the number of employees in the department, and their average salary.
select Dname, count(Ssn), avg(Salary) 
from EMPLOYEE , DEPARTMENT 
where Dno = Dnumber 
group by Dname;

# 3) For each project, retrieve the project number, the project name, and the number of employees who work on that project.
desc PROJECT;
desc WORKS_ON;

select Pnumber, Pname, count(Essn) 
from PROJECT, WORKS_ON 
where Pnumber = Pno 
group by Pno;

# 4) For each project on which more than two employees work, retrieve the project number, the project name, and the number of employees who work on the project.
select Pnumber, Pname, count(Essn) 
from PROJECT, WORKS_ON where Pnumber = Pno 
group by Pno 
having count(Essn) > 2;

# OR 
select Pnumber as PROJ_NUMBER, Pname as PROJ_NAME, count(Essn) as EMP_COUNT 
from PROJECT, WORKS_ON where Pnumber = Pno 
group by Pno 
having EMP_COUNT > 2;

# 5) For each project, retrieve the project number, the project name, and the number of employees from department 5 who work on the project.
select Pnumber, Pname, count(Essn)  
from PROJECT, WORKS_ON where Pnumber = Pno AND Dnum = 5 
group by Pno;

# 6) For each department that has more than two employees, retrieve the department number and the number of its employees who are making more than $40,000.
select Dno, count(Ssn) 
from EMPLOYEE 
where Salary < 40000 
group by Dno having count(Ssn) > 2;

# 7) For each department that has more than two employees, retrieve the department number , 
# department name and the number of its employees who are making more than $40,000.
select Dno, Dname, count(Ssn) 
from EMPLOYEE, DEPARTMENT  
where Dno = Dnumber AND  Salary < 40000 
group by Dno 
having count(Ssn) > 2;

# 8) List the total salary paid to employees in each department, but only for departments with a total salary greater than $100000.
SELECT Dname, SUM(Salary) as total_salary 
FROM DEPARTMENT , EMPLOYEE  
where Dnumber = Dno
GROUP BY Dname HAVING total_salary > 100000;

# 9) List all employees name and salary in the Research department, ordered by their last name
select Lname, Dname, Salary  
from EMPLOYEE, DEPARTMENT 
where Dno = Dnumber and Dname = 'Research' 
order by Lname;

# 10) Select all staff members SSN, Fname, DepartmentName, Salary in ascending order by their Depatment, then by their salary in Descending order:
select Ssn, Fname, Dname , Salary 
from DEPARTMENT, EMPLOYEE 
where Dno = Dnumber 
order by Dname ASC, Salary DESC;

# 11) What is the name of the department with the highest department number?
SELECT Dname , Dnumber 
FROM DEPARTMENT 
ORDER BY Dnumber DESC LIMIT 1;

# 12) Retrieve a list of employees and the projects they are working on,
# ordered by department and, within each department, ordered alphabetically by last name, then first name
SELECT D.Dname, E.Lname, E.Fname, P.Pname 
FROM DEPARTMENT D, EMPLOYEE E, WORKS_ON W, PROJECT P 
WHERE  D.Dnumber= E.Dno AND E.Ssn= W.Essn AND W.Pno= P.Pnumber 
ORDER BY D.Dname, E.Lname, E.Fname;
