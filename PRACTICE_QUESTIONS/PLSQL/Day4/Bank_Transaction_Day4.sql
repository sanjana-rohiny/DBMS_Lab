/*
Write a PL/SQL block to perform necessary updates in the account table upon each transaction ie withdraw/deposit. 

Make sure that minimum balance of Rs1000 is maintained in the account.

Account (Acno(pk), Cname, Balance)
Transaction (Acno(fk), tr_date, amount, deposit/withdraw)

Query: Display the details of transaction done by Aswin

*/

CREATE TABLE Account (
    Acno NUMBER PRIMARY KEY,
    Cname VARCHAR2(50),
    Balance NUMBER
);

-- Create the Transaction table
CREATE TABLE Transaction (
    Tr_id NUMBER PRIMARY KEY,
    Acno NUMBER,
    Tr_date DATE,
    Amount NUMBER,
    Deposit_Withdraw VARCHAR2(10),
    CONSTRAINT fk_account FOREIGN KEY (Acno) REFERENCES Account(Acno)
);

-- Insert sample values into the Account table
INSERT INTO Account (Acno, Cname, Balance) VALUES (101, 'Alice', 1500);
INSERT INTO Account (Acno, Cname, Balance) VALUES (102, 'Bob', 5000);
INSERT INTO Account (Acno, Cname, Balance) VALUES (103, 'Cindy', 500);

select * from Account;


CREATE OR REPLACE TRIGGER UpdateAccountBalance
BEFORE INSERT ON Transaction
FOR EACH ROW
DECLARE
    v_balance Account.Balance%TYPE;
BEGIN
    -- Fetch the current balance of the account
    SELECT Balance INTO v_balance FROM Account WHERE Acno = :NEW.Acno;

    -- Determine the transaction type and update balance accordingly
    IF :NEW.deposit_withdraw = 'deposit' THEN
        v_balance := v_balance + :NEW.amount;
    ELSIF :NEW.deposit_withdraw = 'withdraw' THEN
        IF v_balance - :NEW.amount >= 1000 THEN
            v_balance := v_balance - :NEW.amount;
        ELSE
            raise_application_error(-20001, 'Insufficient balance. Minimum balance of Rs1000 must be maintained.');
        END IF;
    ELSE
        raise_application_error(-20002, 'Invalid transaction type.');
    END IF;

    -- Update the account balance
    UPDATE Account SET Balance = v_balance WHERE Acno = :NEW.Acno;
END;
/

-- TESTING...!
    
-- Insert a sample deposit transaction
INSERT INTO Transaction (Tr_id, Acno, Tr_date, Amount, Deposit_Withdraw) VALUES (1, 101, SYSDATE, 1000, 'deposit');

-- Insert a sample withdrawal transaction
INSERT INTO Transaction (Tr_id, Acno, Tr_date, Amount, Deposit_Withdraw) VALUES (2, 103, SYSDATE, 2000, 'withdraw');


