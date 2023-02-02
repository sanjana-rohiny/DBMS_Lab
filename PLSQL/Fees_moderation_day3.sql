/*
Fees moderation

To implement fee moderation for top 2 students of a class who is having marks greater than
1000/1200.
Student (regno, name, class, fee)
S5 CSE (regno, Sub1, Sub2, Sub3, Sub4, Sub5, Sub6, Sub7, Sub8, totalmarks)
The Sub is the mark of each subject out of 150. Using PL/SQL calculate total marks for each
student in the class. Give a moderation of 10% for the top 2 students of a class and make
necessary modifications in the table.
Query: Display the student details with their marks.

Assuming you have the following tables:

Student table with columns (regno, name, class, fee).
S5_CSE table with columns (regno, Sub1, Sub2, Sub3, Sub4, Sub5, Sub6, Sub7, Sub8,
totalmarks).

You can create a PL/SQL procedure to calculate the total marks for each student, apply
moderation for the top 5 students, and update their fees accordingly. Here&#39;s how the
procedure might look:
*/
drop table Students;

CREATE TABLE Students (
    regno INT PRIMARY KEY,
    name VARCHAR(50),
    class VARCHAR(20),
    fee INT
);
 
drop table S5_CSE;
CREATE TABLE S5_CSE (
    regno INT PRIMARY KEY,
    Sub1 INT,
    Sub2 INT,
    Sub3 INT,
    Sub4 INT,
    Sub5 INT,
    Sub6 INT,
    Sub7 INT,
    Sub8 INT,
    totalmarks INT
);

INSERT INTO Students (regno, name, class, fee) VALUES
(1, 'Alice', 'S5_CSE', 5000);
INSERT INTO Students (regno, name, class, fee) VALUES
(2, 'Bob', 'S5_CSE', 5000);
INSERT INTO Students (regno, name, class, fee) VALUES
(3, 'Cindy', 'S5_CSE', 5000);
INSERT INTO Students (regno, name, class, fee) VALUES
(4, 'Sam', 'S5_CSE', 5000);
INSERT INTO Students (regno, name, class, fee) VALUES
(5, 'Eric', 'S5_CSE', 5000);

INSERT INTO S5_CSE (regno, Sub1, Sub2, Sub3, Sub4, Sub5, Sub6, Sub7, Sub8)
VALUES (1, 100, 120, 130, 140, 150, 120, 110, 100);
INSERT INTO S5_CSE (regno, Sub1, Sub2, Sub3, Sub4, Sub5, Sub6, Sub7, Sub8)
VALUES (2, 80, 90, 110, 120, 80, 70, 100, 140);
INSERT INTO S5_CSE (regno, Sub1, Sub2, Sub3, Sub4, Sub5, Sub6, Sub7, Sub8)
VALUES (3, 120, 110, 100, 80, 90, 130, 140, 100);
INSERT INTO S5_CSE (regno, Sub1, Sub2, Sub3, Sub4, Sub5, Sub6, Sub7, Sub8)
VALUES (4, 140, 120, 150, 130, 110, 140, 150, 120);
INSERT INTO S5_CSE (regno, Sub1, Sub2, Sub3, Sub4, Sub5, Sub6, Sub7, Sub8)
VALUES (5, 150, 150, 140, 130, 140, 120, 130, 120);

select * from Students;
select * from S5_CSE;

CREATE OR REPLACE PROCEDURE calculate_total_marks_and_moderate_fee AS
total int;
BEGIN
    FOR rec IN (select * from S5_CSE) LOOP
        dbms_output.put_line('regno : ' || rec.regno);
        rec.totalmarks :=  rec.Sub1 + rec.Sub2 + rec.Sub3 + rec.Sub4 + 
                          rec.Sub5 + rec.Sub6 + rec.Sub7 + rec.Sub8;  
        dbms_output.put_line('totalmarks : ' || rec.totalmarks);
        -- Update total marks
        update S5_CSE set totalmarks = rec.totalmarks where regno = rec.regno;
        dbms_output.put_line('---------------------------');
    END LOOP;
    
    FOR rec IN (select * from S5_CSE where totalmarks > 1000 
        order by totalmarks desc FETCH FIRST 3 ROWS ONLY) LOOP
        dbms_output.put_line('totalmarks : ' || rec.totalmarks);
        -- give fee moderation
        update Students set fee = round(fee*0.9) where regno = rec.regno;
    END LOOP;
END;

/*
Test PL/SQL Program..!
*/
BEGIN
calculate_total_marks_and_moderate_fee;
END;

select * from Students;
select * from S5_CSE;
/