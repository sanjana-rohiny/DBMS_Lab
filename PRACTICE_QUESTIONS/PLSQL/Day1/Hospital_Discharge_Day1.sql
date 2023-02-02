/* PL/SQL Trigger to backup discharge summary of patient during discharge. 
The patient has to pay Rs1000 for non ac and Rs1500 for Ac room per day. 
Also ensure that discharge is not possible on Sundays

Patient (pid, pname, department, dateofadmission, roomtype(ac/nonac), status(admit/Discharge))
Admit_history(pid, pname, department, roomtype, daysadmitted, billamount)

Query: Display the patients who got discharge on 9 Feb 2023 with their bill amount.
*/

drop table Patient;
drop table Admit_history;

-- Create the Patient table
CREATE TABLE Patient (
    pid NUMBER PRIMARY KEY,
    pname VARCHAR2(50),
    department VARCHAR2(50),
    dateofadmission DATE,
    roomtype VARCHAR2(10),
    status VARCHAR2(20)
);

-- Create the Admit_history table
CREATE TABLE Admit_history (
    pid NUMBER,
    pname VARCHAR2(50),
    department VARCHAR2(50),
    roomtype VARCHAR2(10),
    daysadmitted NUMBER,
    billamount NUMBER
);

-- Insert sample data into the Patient table
INSERT INTO Patient (pid, pname, department, dateofadmission, roomtype, status)
VALUES (1, 'John Doe', 'Cardiology', TO_DATE('2023-02-06', 'YYYY-MM-DD'), 'nonac', 'Admit');

INSERT INTO Patient (pid, pname, department, dateofadmission, roomtype, status)
VALUES (2, 'Jane Smith', 'Orthopedics', TO_DATE('2023-02-07', 'YYYY-MM-DD'), 'ac', 'Admit');

INSERT INTO Patient (pid, pname, department, dateofadmission, roomtype, status)
VALUES (3, 'Bob Johnson', 'Neurology', TO_DATE('2023-02-08', 'YYYY-MM-DD'), 'nonac', 'Admit');

-- Create a trigger to handle the discharge and backup of summary
CREATE OR REPLACE TRIGGER discharge_summary_trigger
AFTER UPDATE OF status ON Patient
FOR EACH ROW
DECLARE
    discharge_date DATE;
    days_admitted NUMBER;
    room_rate NUMBER;
    total_bill_amount NUMBER;
BEGIN
    IF :NEW.status = 'Discharge' AND :OLD.status = 'Admit' THEN
        -- Get the discharge date
        discharge_date := SYSDATE;
        DBMS_OUTPUT.PUT_LINE(':OLD.pname ' || :OLD.pname);
        DBMS_OUTPUT.PUT_LINE(':OLD.status ' || :OLD.status);
        DBMS_OUTPUT.PUT_LINE(':NEW.status ' || :NEW.status);

        -- Check if the discharge date is not a Sunday
        IF TO_CHAR(discharge_date, 'D') != '7' THEN
            DBMS_OUTPUT.PUT_LINE('discharge_date not Sunday');

            -- Calculate the number of days admitted
            days_admitted := TRUNC(discharge_date) - TRUNC(:OLD.dateofadmission);
            DBMS_OUTPUT.PUT_LINE('days_admitted = ' || days_admitted);
            DBMS_OUTPUT.PUT_LINE(':OLD.roomtype ' || :OLD.roomtype);

            -- Get the room rate based on room type
            IF :OLD.roomtype = 'ac' THEN
                room_rate := 1500;
            ELSE
                room_rate := 1000;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE('room_rate ' || room_rate);

            -- Calculate the total bill amount
            total_bill_amount := days_admitted * room_rate;
            DBMS_OUTPUT.PUT_LINE('total_bill_amount ' || total_bill_amount);

            -- Update the Admit_history table with the discharge summary
            INSERT INTO Admit_history (pid, pname, department, roomtype, daysadmitted, billamount)
            VALUES (:OLD.pid, :OLD.pname, :OLD.department, :OLD.roomtype, days_admitted, total_bill_amount);
        END IF;
    END IF;
END;
/

-- Test program
BEGIN
-- Suppose we want to discharge the patient with pid = 1
    UPDATE Patient
    SET status = 'Discharge'
    WHERE pid = 1;
END;

select * from Patient;
select * from  Admit_history;
truncate table Patient;
truncate table Admit_history;
