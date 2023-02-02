/*
College Admission
To implement admission of the college
1.	Close the admission of college after �30-Nov-2023�
2.	Update the number of vacancies and admitted after inserting/updating /deleting a student details in the admission table.

College_vacancies(br_id(pk),deptname,totalseats,admitted,vacancy)
admission(br_id(fk),sid(auto_generate),sname,Dob,Address,m_phy,m_che,m_bio_com,m_maths,m_tot)
Query: Display the students details applied for admission in CSE branch.

Ans: on insert,  
        1- if admission date is > 30-Nov-2023 --> disallow 
        2- else if totalseats > admitted+1 --> disallow
        3- else -> set admitted = admitted+1, and vacancy = vacancy-1
     on delete
        update College_vacancies
            set admitted = admitted-1 and vacancy = vacancy+1
     on update branch_id
            check if new branch has totalseats > admitted+1 -> disallow
            else update old branch admitted = admitted - 1, vacancy = vacancy+1
                 update new branch admitted = admitted + 1, vacancy = vacancy-1 
*/

drop table College_vacancies;
drop table admission;
drop sequence admission_sid_seq;

-- Create College_vacancies table
CREATE TABLE College_vacancies (
    br_id NUMBER PRIMARY KEY,
    deptname VARCHAR2(50),
    totalseats NUMBER,
    admitted NUMBER,
    vacancy NUMBER
);

-- Create admission table
CREATE TABLE admission (
    br_id NUMBER,
    sid NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    sname VARCHAR2(50),
    Dob DATE,
    Address VARCHAR2(100),
    m_phy NUMBER,
    m_che NUMBER,
    m_bio_com NUMBER,
    m_maths NUMBER,
    m_tot NUMBER,
    CONSTRAINT fk_br_id FOREIGN KEY (br_id) REFERENCES College_vacancies (br_id)
);
/*
CREATE TABLE admission (
    br_id NUMBER,
    sid NUMBER PRIMARY KEY,
    sname VARCHAR2(50),
    Dob DATE,
    Address VARCHAR2(100),
    m_phy NUMBER,
    m_che NUMBER,
    m_bio_com NUMBER,
    m_maths NUMBER,
    m_tot NUMBER,
    CONSTRAINT fk_br_id FOREIGN KEY (br_id) REFERENCES College_vacancies (br_id)
);

CREATE SEQUENCE admission_sid_seq START WITH 100;
-- Use admission_sid_seq.NEXTVAL
*/

-- populate College_vacancies
-- Inserting data for the CSE branch
INSERT INTO College_vacancies (br_id, deptname, totalseats, admitted, vacancy)
VALUES (1, 'CSE', 50, 0, 50);
-- Inserting data for the AI branch
INSERT INTO College_vacancies (br_id, deptname, totalseats, admitted, vacancy)
VALUES (2, 'AI', 50, 0, 50);
-- Inserting data for the MECH branch
INSERT INTO College_vacancies (br_id, deptname, totalseats, admitted, vacancy)
VALUES (3, 'MECH', 50, 0, 50);
-- Inserting data for the EEE branch
INSERT INTO College_vacancies (br_id, deptname, totalseats, admitted, vacancy)
VALUES (4, 'EEE', 50, 0, 50);

-- Create a trigger to update College_vacancies after insert/update/delete in admission
CREATE OR REPLACE TRIGGER update_college_vacancies
AFTER INSERT OR UPDATE OR DELETE ON admission
FOR EACH ROW
DECLARE
    admission_date DATE;
    num_admitted NUMBER;
    num_deleted NUMBER;
    v_totalseats College_vacancies.totalseats % TYPE;
    v_vacancy College_vacancies.vacancy % TYPE;

BEGIN
    -- Check if the admission date is before or after '30-Nov-2021'
    SELECT SYSDATE INTO admission_date FROM DUAL;
    
    IF admission_date <= TO_DATE('2023-11-30', 'YYYY-MM-DD') THEN
        IF INSERTING THEN
            -- get total seat
            select totalseats, vacancy into v_totalseats, v_vacancy 
            from College_vacancies where br_id = :NEW.br_id;
            DBMS_OUTPUT.PUT_LINE('v_vacancy = ' || v_vacancy);
            if v_vacancy > 0 then
                DBMS_OUTPUT.PUT_LINE('Update College_vacancies table');
                update College_vacancies 
                set admitted = admitted+1, vacancy = vacancy - 1
                where br_id = :NEW.br_id;
            else
                DBMS_OUTPUT.PUT_LINE('NO VACANCY...!');
                RAISE_APPLICATION_ERROR(-20001, 'NO VACANCY...!');
            end if;
            
        ELSIF UPDATING THEN
            DBMS_OUTPUT.PUT_LINE('Update College_vacancies table');
            -- Update College_vacancies table when a student is deleted
            -- check if new brach has vacancy
            DBMS_OUTPUT.PUT_LINE(:NEW.br_id);
            DBMS_OUTPUT.PUT_LINE(:OLD.br_id);

            select totalseats, vacancy into v_totalseats, v_vacancy 
            from College_vacancies where br_id = :NEW.br_id;
            if v_vacancy > 0 then
                -- update vacancy table - new btanch
                update College_vacancies 
                set admitted = admitted+1, vacancy = vacancy - 1
                where br_id = :NEW.br_id;
                -- update vacancy table - old btanch
                update College_vacancies 
                set admitted = admitted-1, vacancy = vacancy + 1
                where br_id = :OLD.br_id;
            else
                DBMS_OUTPUT.PUT_LINE('NO VACANCY...!');
                RAISE_APPLICATION_ERROR(-20001, 'NO VACANCY...!');
            end if;            
        ELSIF DELETING THEN
            DBMS_OUTPUT.PUT_LINE('DELETING!');
            update College_vacancies 
            set admitted = admitted-1, vacancy = vacancy + 1
            where br_id = :OLD.br_id;  
            
        END IF;
    ELSE
        -- Raise an exception to prevent admission after the closing date
        RAISE_APPLICATION_ERROR(-20001, 'Admission closed after 30-Nov-2021.');
    END IF;
END;
/

-- Insert students' details into the "admission" table
-- We assume that the College_vacancies table has a record for the CSE department with 50 total seats and 0 admissions initially.
-- The trigger will update the College_vacancies table after each insertion.

-- Insert student 1 details
INSERT INTO admission (br_id, sname, Dob, Address, m_phy, m_che, m_bio_com, m_maths, m_tot)
VALUES (1, 'Alice', TO_DATE('2000-01-15', 'YYYY-MM-DD'), 'Address1', 90, 85, 80, 95, 350);

-- Insert student 2 details
INSERT INTO admission (br_id, sname, Dob, Address, m_phy, m_che, m_bio_com, m_maths, m_tot)
VALUES (2, 'Bob', TO_DATE('1999-05-10', 'YYYY-MM-DD'), 'Address2', 85, 90, 75, 80, 330);

-- Update student 2 details
UPDATE admission
SET br_id = 4
WHERE sid = 7;

-- Delete student 1
DELETE FROM admission
WHERE sid = 8;

-- Insert student 3 details
INSERT INTO admission (br_id, sname, Dob, Address, m_phy, m_che, m_bio_com, m_maths, m_tot)
VALUES (1, 'Carol', TO_DATE('2001-08-20', 'YYYY-MM-DD'), '789 Oak St', 88, 95, 82, 88, 353);

select * from  College_vacancies;
select * from admission;
truncate table College_vacancies;
truncate table admission;