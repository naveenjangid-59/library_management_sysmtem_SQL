USE lms;

-- Retrieve All Books Issued by a Specific Employee 
SELECT * 
FROM issued_status
WHERE issued_emp_id = 'E105';

-- List members who have issued more than one book
SELECT issued_emp_id,COUNT(*) AS no_of_issued_books
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*)>1;


-- how many times a book has been issued (Count)
SELECT isbn,book_title,COUNT(*) 
FROM books b
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY isbn
ORDER BY COUNT(*) DESC;



-- total rental income by a category
SELECT category,SUM(rental_price),COUNT(*)
FROM books b
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY category
ORDER BY SUM(rental_price) DESC;



-- list employees with their b ranch manager's name and their branch details
WITH t AS
	(SELECT emp_id,emp_name,position,branch_id,manager_id
	FROM employees e
	JOIN branch b 
	ON b.branch_id = e.emp_branch_id)
SELECT t.emp_id,t.emp_name,t.position AS emp_position,e2.emp_name AS manager_name,e2.emp_id 
FROM t
JOIN employees e2 
ON e2.emp_id = t.manager_id;



-- List of books yet not returned
WITH t AS(SELECT ist.issued_id,ist.issued_book_isbn,rst.return_id
FROM issued_status ist
LEFT JOIN return_status rst
ON ist.issued_id = rst.issued_id
WHERE rst.return_id IS NULL)
SELECT t.issued_id, b.isbn, b.book_title FROM t
JOIN books b
ON t.issued_book_isbn = b.isbn;



-- Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's name, book title, issue date, and days overdue.
WITH temp AS 
	(WITH t AS(SELECT ist.issued_id,ist.issued_book_isbn,rst.return_id,ist.issued_member_id,ist.issued_date
	FROM issued_status ist
	LEFT JOIN return_status rst
	ON ist.issued_id = rst.issued_id
	WHERE rst.return_id IS NULL)
	SELECT t.issued_id,t.issued_member_id,t.issued_date, b.isbn,b.book_title,m.member_name FROM t
	JOIN books b
	ON t.issued_book_isbn = b.isbn
	JOIN members m
	ON m.member_id = t.issued_member_id)
SELECT *,DATEDIFF(NOW(), issued_date) AS days_issued_ago FROM temp
WHERE DATEDIFF(NOW(), issued_date) > 30;



-- stored procedure to get a return entry of a book (input fields - issued_id,book_condition)
CALL return_book('IS144','damaged');


-- stored procedure to make book issue entry (input fields - member_id,book_isbn,emp_id)
CALL issue_book('C102','978-0-14-118776-1','E103');


-- branch_performance_report (number of book issued, number of books returned,revenue generated)
SELECT e.emp_branch_id AS branch_id,SUM(b.rental_price),COUNT(*)
FROM issued_status ist
JOIN employees e
ON ist.issued_emp_id = e.emp_id
JOIN books b
ON ist.issued_book_isbn = b.isbn
GROUP BY emp_branch_id;


-- Create a Table of active_members containing members who have issued at least one book in the last 6 months.
WITH m2 AS(WITH t AS (SELECT *
FROM issued_status 
WHERE issued_date >= DATE(NOW()) - INTERVAL 6 MONTH)
SELECT m.member_id,COUNT(*) AS num_of_times FROM t
JOIN members m
ON t.issued_member_id = m.member_id
GROUP BY m.member_id)
SELECT m2.member_id,m3.member_name,m2.num_of_times FROM m2
JOIN members m3
ON m3.member_id = m2.member_id;

-- Find Employees with the Most Book Issues Processed
WITH t AS
	(
		SELECT issued_member_id,COUNT(*) AS count
		FROM lms.issued_status
		GROUP BY issued_member_id
		ORDER BY COUNT(*) DESC
	)
SELECT 
issued_member_id AS member_id,member_name,count
FROM t
JOIN members m
ON t.issued_member_id = m.member_id;


-- find employees which possibly harm books or return damaged books
WITH t AS 
	(SELECT * FROM return_status 
	 WHERE book_condition = 'damaged')
SELECT member_id,member_name,COUNT(*) AS count
FROM t
JOIN issued_status ist
ON t.issued_id = ist.issued_id
JOIN members m
ON m.member_id = ist.issued_member_id
GROUP BY member_id,member_name
ORDER BY count DESC;
























