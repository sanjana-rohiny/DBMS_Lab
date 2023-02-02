/*
Student Database

PL/SQL procedure to calculate the Total marks 
and Grade of Dbms of students and add to corresponding tables. 

Student (Rno, Name, dbms, os, maths, mp, lsd, pe,total_marks(calculate using program))
Grade(rno, g_dbms,g_os,g_maths, g_mp, g_lsd,g_pe)
Grade calculation: (mark>90 -S, total between 80 – 90 A+, total between 80 – 90 A+ etc). 

Query: Display the Marklist of students.

*/
truncate table Student;
truncate table Grade;
drop table Student;
drop table Grade;

-- Create the Student table
CREATE TABLE Student (
    Rno INT PRIMARY KEY,
    Name VARCHAR(100),
    dbms INT,
    os INT,
    maths INT,
    mp INT,
    lsd INT,
    pe INT,
    total_marks INT
);

-- Create the Grade table
CREATE TABLE Grade (
    rno INT PRIMARY KEY,
    g_dbms VARCHAR(10),
    g_os VARCHAR(10),
    g_maths VARCHAR(10),
    g_mp VARCHAR(10),
    g_lsd VARCHAR(10),
    g_pe VARCHAR(10),
    CONSTRAINT fk_rno FOREIGN KEY (rno) REFERENCES Student (Rno)
);

-- Inserting values into the Student table
INSERT INTO Student (Rno, Name, dbms, os, maths, mp, lsd, pe)
VALUES(1, 'Alice', 90, 85, 75, 80, 70, 95);
INSERT INTO Student (Rno, Name, dbms, os, maths, mp, lsd, pe) 
VALUES(2, 'Bob', 85, 90, 80, 75, 60, 90);
INSERT INTO Student (Rno, Name, dbms, os, maths, mp, lsd, pe) 
VALUES(3, 'Cindy', 70, 75, 85, 95, 80, 85);
INSERT INTO Student (Rno, Name, dbms, os, maths, mp, lsd, pe) 
VALUES(4, 'Sam', 80, 70, 90, 85, 75, 80);
INSERT INTO Student (Rno, Name, dbms, os, maths, mp, lsd, pe) 
VALUES(5, 'Eric', 95, 80, 70, 60, 90, 70);

select * from  Student;
select * from Grade;

CREATE OR REPLACE FUNCTION Calculate_Grade(mark INT) RETURN VARCHAR2 IS
    grade VARCHAR2(10);
BEGIN
    IF mark > 90 THEN
        grade := 'S';
    ELSIF mark >= 80 THEN
        grade := 'A+';
    ELSIF mark >= 70 THEN
        grade := 'A';
    ELSIF mark >= 60 THEN
        grade := 'B';
    ELSIF mark >= 50 THEN
        grade := 'C';
    ELSE
        grade := 'F';
    END IF;
    
    RETURN grade;
END;
/


-- Create the Calculate_Total_Marks_Grade procedure
CREATE OR REPLACE PROCEDURE Calculate_Total_Marks_Grade AS
    grade_g_dbms VARCHAR2(10);
    grade_g_os VARCHAR2(10);
    grade_g_maths VARCHAR2(10);
    grade_g_mp VARCHAR2(10);
    grade_g_lsd VARCHAR2(10);
    grade_g_pe VARCHAR2(10);
    v_total_marks Student.total_marks % TYPE;
BEGIN
    FOR rec IN (SELECT Rno, dbms, os, maths, mp, lsd, pe FROM Student) LOOP
        -- Calculate total marks
        v_total_marks := rec.dbms + rec.os + rec.maths + rec.mp + rec.lsd + rec.pe;
        
        -- Calculate grades using Calculate_Grade function
        grade_g_dbms := Calculate_Grade(rec.dbms);
        grade_g_os := Calculate_Grade(rec.os);
        grade_g_maths := Calculate_Grade(rec.maths);
        grade_g_mp := Calculate_Grade(rec.mp);
        grade_g_lsd := Calculate_Grade(rec.lsd);
        grade_g_pe := Calculate_Grade(rec.pe);

        -- Insert/update grades into the Grade table
        INSERT INTO Grade (rno, g_dbms, g_os, g_maths, g_mp, g_lsd, g_pe)
        VALUES (rec.rno, grade_g_dbms, grade_g_os, grade_g_maths, grade_g_mp, grade_g_lsd, grade_g_pe);

        -- Update total_marks in the Student table
        UPDATE Student
        SET total_marks = v_total_marks
        WHERE Rno = rec.rno;
    END LOOP;
    COMMIT;
END;
/


DECLARE
BEGIN
    Calculate_Total_Marks_Grade;
    DBMS_OUTPUT.PUT_LINE('Grades and total marks calculated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

select * from  Student;
select * from Grade;
