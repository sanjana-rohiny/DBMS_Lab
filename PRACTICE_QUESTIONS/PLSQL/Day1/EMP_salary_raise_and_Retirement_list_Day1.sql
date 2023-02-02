
drop table Dept;
drop table Emp;
drop table Project;
drop table Emp_History;
select * from Project;

truncate table Emp;
CREATE TABLE Dept (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    Dept_head VARCHAR(50)
);
CREATE TABLE Emp (
    eno INT PRIMARY KEY,
    ename VARCHAR(50),
    designation VARCHAR(50),
    address VARCHAR(100),
    sal DECIMAL(10, 2),
    ph_no VARCHAR(15),
    dojoin DATE,
    dob DATE,
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES Dept(deptno)
);
CREATE TABLE Project (
    Pno INT,
    Deptno INT,
    eno INT,
    Pname VARCHAR(100),
    PRIMARY KEY (Pno, Deptno),
    FOREIGN KEY (eno) REFERENCES Emp(eno),
    FOREIGN KEY (Deptno) REFERENCES Dept(deptno)
);
CREATE TABLE Emp_History (
    eno INT,
    retirement_sal DECIMAL(10, 2),
    address VARCHAR(100),
    date_of_retirement DATE,
    years_of_experience INT
);

INSERT INTO Dept (deptno, dname, Dept_head) VALUES (1, 'HR', 'Alice');
INSERT INTO Dept (deptno, dname, Dept_head) VALUES (2, 'RnD', 'Bob');
INSERT INTO Dept (deptno, dname, Dept_head) VALUES (3, 'Finance', 'Cindy');

INSERT INTO Emp (eno, ename, designation, address, sal, ph_no, dojoin, dob, deptno)
VALUES (1, 'Alice', 'Manager', 'Address1', 50000, '9880975544', TO_DATE('2020-01-01', 'YYYY-MM-DD'), TO_DATE('1980-05-10', 'YYYY-MM-DD'), 1);

INSERT INTO Emp (eno, ename, designation, address, sal, ph_no, dojoin, dob, deptno)
VALUES (2, 'Bob', 'Manager', 'Address2', 40000, '9880975545', TO_DATE('2021-06-15', 'YYYY-MM-DD'), TO_DATE('1990-09-20', 'YYYY-MM-DD'), 2);

INSERT INTO Emp (eno, ename, designation, address, sal, ph_no, dojoin, dob, deptno)
VALUES (3, 'Cindy', 'Manager', 'Address3', 30000, '9880975546', TO_DATE('2018-03-01', 'YYYY-MM-DD'), TO_DATE('1985-02-05', 'YYYY-MM-DD'), 3);

INSERT INTO Emp (eno, ename, designation, address, sal, ph_no, dojoin, dob, deptno)
VALUES (4, 'David', 'Enginner', 'Address4', 30000, '9880975547', TO_DATE('2018-03-01', 'YYYY-MM-DD'), TO_DATE('1968-02-05', 'YYYY-MM-DD'), 3);

INSERT INTO Emp (eno, ename, designation, address, sal, ph_no, dojoin, dob, deptno)
VALUES (5, 'Eric', 'Enginner', 'Address5', 30000, '9880975547', TO_DATE('2018-03-01', 'YYYY-MM-DD'), TO_DATE('1967-02-05', 'YYYY-MM-DD'), 3);

DECLARE
    -- Define constants for salary increase percentages
    hr_increase CONSTANT NUMBER := 1.20;
    rd_increase CONSTANT NUMBER := 1.30;
    other_increase CONSTANT NUMBER := 1.10;
    
    -- Define the retiring age
    retiring_age CONSTANT NUMBER := 55;
    
    -- Declare a variable to store the reference date
    reference_date DATE := TO_DATE('2023-03-31', 'YYYY-MM-DD');
    
    years_of_experience int := 0;
BEGIN
    -- Update HR salaries by 20%
    UPDATE Emp
    SET sal = sal * hr_increase
    WHERE deptno = 1;

    -- Update R&D salaries by 30%
    UPDATE Emp
    SET sal = sal * rd_increase
    WHERE deptno = 2;

    -- Update salaries of all other departments by 10%
    UPDATE Emp
    SET sal = sal * other_increase
    WHERE deptno NOT IN (1, 2);
    
    -- Identify retiring staffs
    FOR emp_rec IN (SELECT * FROM Emp) LOOP
        -- Calculate the age as of 31st March 2022
        DECLARE
            age_at_reference_date NUMBER;
        BEGIN
            age_at_reference_date := FLOOR(MONTHS_BETWEEN(reference_date, emp_rec.dob) / 12);
            DBMS_OUTPUT.PUT_LINE('age_at_reference_date ' || age_at_reference_date);

            IF age_at_reference_date >= retiring_age THEN
                DBMS_OUTPUT.PUT_LINE('Eno = ' || emp_rec.eno || ' Name =  ' || emp_rec.ename || ' is retiring..!');
               
                -- insert retiring staff into into Emp_History table
                years_of_experience := FLOOR(MONTHS_BETWEEN(reference_date, emp_rec.dojoin) / 12);
                INSERT INTO Emp_History (eno, retirement_sal, address, date_of_retirement, years_of_experience)
                VALUES (emp_rec.eno, emp_rec.sal,  emp_rec.address, reference_date, years_of_experience);

                -- delete retiring staff into from Emp table
                DBMS_OUTPUT.PUT_LINE('Deleting Eno = ' || emp_rec.eno || ' Name =  ' || emp_rec.ename || ' is retiring..!');
                delete from Emp where eno = emp_rec.eno;
            END IF;
        END;
    END LOOP;
END;
/

select * from Emp;
select * from Dept;
select * from Emp_History;
truncate table Emp_History;
truncate table Emp;
