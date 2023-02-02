/*
Write a PL/SQL block to perform the following action.
    
Calculate commissions for sales persons for the month of January and add the details into Commission. 
When the total sale is less than or equal to Rs.10,000 the rate of commission is 1% and 
if it is greater than 10,000 the commission will be 2% of sale amount.

Salesman_Details (s_id, s_name, salary)
Sales (sid, sale_amount, month)
Commission (sid, commission_amount, month)

*/

-- Create the Salesman_Details table
CREATE TABLE Salesman_Details (
    s_id NUMBER PRIMARY KEY,
    s_name VARCHAR2(50),
    salary NUMBER
);

-- Create the Sales table
CREATE TABLE Sales (
    sid NUMBER,
    sale_amount NUMBER,
    month VARCHAR2(20)
);

-- Create the Commission table
CREATE TABLE Commission (
    sid NUMBER,
    commission_amount NUMBER,
    month VARCHAR2(20)
);

-- Insert sample values into the Salesman_Details table
INSERT INTO Salesman_Details (s_id, s_name, salary) VALUES (1, 'Alicec', 3000);
INSERT INTO Salesman_Details (s_id, s_name, salary) VALUES (2, 'Bob', 4000);

-- Insert sample sales data for January
INSERT INTO Sales (sid, sale_amount, month) VALUES (1, 8000, 'January');
INSERT INTO Sales (sid, sale_amount, month) VALUES (2, 12000, 'January');


CREATE OR REPLACE PROCEDURE CalculateCommissions(p_month IN VARCHAR2) IS
    v_commission_rate NUMBER;
    v_total_sale NUMBER;

BEGIN
    -- Loop through the Salesman_Details table to calculate and insert commissions
    FOR salesman_rec IN (SELECT s_id, s_name, salary FROM Salesman_Details) LOOP
        -- Calculate total sale amount for the salesman for the given month
        BEGIN
            SELECT SUM(sale_amount) INTO v_total_sale
            FROM Sales
            WHERE sid = salesman_rec.s_id AND month = p_month;

            -- Calculate commission rate based on total sale
            IF v_total_sale <= 10000 THEN
                v_commission_rate := 0.01; -- 1%
            ELSE
                v_commission_rate := 0.02; -- 2%
            END IF;
        END;

        -- Calculate commission amount
        DECLARE
            v_commission_amount NUMBER := v_total_sale * v_commission_rate;
        BEGIN
            -- Insert commission details into Commission table
            INSERT INTO Commission (sid, commission_amount, month)
            VALUES (salesman_rec.s_id, v_commission_amount, p_month);
            
            -- Print commission details for each salesman
            DBMS_OUTPUT.PUT_LINE('Commission details for ' || salesman_rec.s_name || ':');
            DBMS_OUTPUT.PUT_LINE('Commission Amount: Rs. ' || v_commission_amount);
            DBMS_OUTPUT.PUT_LINE('--------------------------------');
        END;
    END LOOP;
    
    COMMIT; -- Commit the changes
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK; -- Rollback changes in case of error
END CalculateCommissions;
/


BEGIN
    CalculateCommissions('January');
END;
/


