/*
Library database
Tables:

BookDetails : Book_No (pk),category (Educational,Fiction,Autobigraphy, Novel),
book_name, author, issued_status(y/n)
Book_issued :issueid(pk), std_id (fk), Book_No(fk), issued_date, return_date
StudentDetails : std_id (pk), book_No (fk), std_name, Dept, Total_fine(set default as 0)

Write a PL/SQL program to perform book return using procedure. 
Calculate the fine of a student in a library. 
If a book is already issued for more than 15 days, apply a fine of Rs2/ per
day to that student.

Query: Display the Students who have taken Novels 
To perform book return and calculate fines for students in a library, you can create a PL/SQL
procedure that handles the book return process and calculates fines if applicable. 
*/
ALTER SESSION SET CONSTRAINTS = DEFERRED;
SET CONSTRAINTS ALL IMMEDIATE;

drop table BookDetails;
drop table StudentDetails;
drop table Book_issued;

CREATE TABLE BookDetails (
    Book_No INT PRIMARY KEY,
    category VARCHAR(20) CHECK (category IN ('Educational', 'Fiction', 'Autobiography', 'Novel')),
    book_name VARCHAR(100),
    author VARCHAR(100),
    issued_status CHAR(1) CHECK (issued_status IN ('y', 'n'))
);
CREATE TABLE StudentDetails (
    std_id INT PRIMARY KEY,
    book_No INT,
    std_name VARCHAR(100),
    Dept VARCHAR(50),
    Total_fine DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (book_No) REFERENCES BookDetails(Book_No)
);
CREATE TABLE Book_issued (
    issueid INT PRIMARY KEY,
    std_id INT,
    Book_No INT,
    issued_date DATE,
    return_date DATE,
    FOREIGN KEY (std_id) REFERENCES StudentDetails(std_id),
    FOREIGN KEY (Book_No) REFERENCES BookDetails(Book_No)
);

-- Insert data into BookDetails table
INSERT INTO BookDetails (Book_No, category, book_name, author, issued_status)
VALUES (1, 'Educational', 'Book1', 'Author1', 'n');
INSERT INTO BookDetails (Book_No, category, book_name, author, issued_status)
VALUES (2, 'Fiction', 'Book2', 'Author2', 'y');
INSERT INTO BookDetails (Book_No, category, book_name, author, issued_status)
VALUES (3, 'Novel', 'Book3', 'Author3', 'n');
INSERT INTO BookDetails (Book_No, category, book_name, author, issued_status)
VALUES (4, 'Educational', 'Book4', 'Author4', 'n');
INSERT INTO BookDetails (Book_No, category, book_name, author, issued_status)
VALUES (5, 'Autobiography', 'Book5', 'Author5', 'y');

-- Insert data into StudentDetails table
INSERT INTO StudentDetails (std_id, book_No, std_name, Dept)
VALUES (1, 2, 'Student1', 'Department1');
INSERT INTO StudentDetails (std_id, book_No, std_name, Dept)
VALUES (2, 3, 'Student2', 'Department2');
INSERT INTO StudentDetails (std_id, book_No, std_name, Dept)
VALUES (3, 4, 'Student3', 'Department3');
INSERT INTO StudentDetails (std_id, book_No, std_name, Dept)
VALUES (4, 1, 'Student4', 'Department4');
INSERT INTO StudentDetails (std_id, book_No, std_name, Dept)
VALUES (5, 5, 'Student5', 'Department5');

-- Insert data into Book_issued table
INSERT INTO Book_issued (issueid, std_id, Book_No, issued_date)
VALUES (1, 2, 2, TO_DATE('2023-07-15','%yyyy-%mm-%dd'));  
INSERT INTO Book_issued (issueid, std_id, Book_No, issued_date)
VALUES (2, 4, 1, TO_DATE('2023-07-20','%yyyy-%mm-%dd'));  
INSERT INTO Book_issued (issueid, std_id, Book_No, issued_date, return_date)
VALUES (3, 5, 3, TO_DATE('2023-07-25','%yyyy-%mm-%dd'));  

-- PL/SQL Default Date format : '15-JULY-23' TO_DATE() conversoin is not needed.
CREATE OR REPLACE PROCEDURE return_book(p_issue_id IN
Book_issued.issueid%TYPE) AS
    v_fine_per_day NUMBER := 2;
    v_fine_amount NUMBER := 0;
    v_issued_date DATE;
    v_return_date DATE := SYSDATE;
    v_std_id int;
    v_book_No int;
    v_no_of_days int := 0;
BEGIN
    select issued_date, std_id, book_No 
    into v_issued_date, v_std_id, v_book_No 
    from Book_issued
    where  issueid = p_issue_id;
    dbms_output.put_line('issueid : ' || p_issue_id);
    dbms_output.put_line('std_id : ' || v_std_id);
    dbms_output.put_line('Book_No : ' || v_book_No);
    dbms_output.put_line('issued_date : ' || v_issued_date);
    dbms_output.put_line('return_date : ' || v_return_date);
    v_no_of_days := v_return_date - v_issued_date;
    dbms_output.put_line('v_no_of_days : ' || v_no_of_days);
    
    -- update book table when book is returned...!
    update Book_issued 
    set return_date = v_return_date 
    where issueid = p_issue_id;
    
    -- update file StudentDetails
    if (v_no_of_days > 15) then
        v_fine_amount := v_no_of_days * v_fine_per_day;
        dbms_output.put_line('FINE Amount' || v_fine_amount);
        
        update StudentDetails 
        set Total_fine = v_fine_amount 
        where std_id = v_std_id;
    else
        dbms_output.put_line('FINE Not Required');
    end if;
    
    -- update file BookDetails:issued_status
    update BookDetails 
    set issued_status = 'n' 
    where Book_No = v_book_No;
    dbms_output.put_line('BookDetails:issued_status Updated to -n');

    dbms_output.put_line('---------------------------');
END;

/*
Test PL/SQL Program..!
*/
BEGIN
return_book(1);
END;

select * from Book_issued;
select * from StudentDetails;
select * from BookDetails;
