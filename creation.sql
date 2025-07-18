USE lms;


-- create branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
	branch_id VARCHAR(45) PRIMARY KEY,
    manager_id VARCHAR(45),
    branch_adress VARCHAR(45),
    contact_no VARCHAR(45)
);


-- create employees table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
	emp_id VARCHAR(45) PRIMARY KEY,
    emp_name VARCHAR(45),
    position VARCHAR(45),
    salary DECIMAL(10,2),
    emp_branch_id VARCHAR(45) -- FK
);

-- create employees table
DROP TABLE IF EXISTS books;
CREATE TABLE books(
	isbn VARCHAR(255) PRIMARY KEY,
    book_title VARCHAR(255),
    category VARCHAR(255),
    rental_price DECIMAL(5,2),
    status VARCHAR(255),
    author VARCHAR(255),
    publisher VARCHAR(255)
);

-- create employees table
DROP TABLE IF EXISTS members;
CREATE TABLE members(
	member_id VARCHAR(255) PRIMARY KEY,
    member_name VARCHAR(255),
    member_address VARCHAR(255),
    reg_date DATE
);



-- create employees table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
	issued_id VARCHAR(255) PRIMARY KEY,
    issued_member_id VARCHAR(255),  -- FK
    issued_date DATE,
    issued_book_isbn VARCHAR(255), -- FK
	issued_emp_id VARCHAR(255)  -- FK
);

-- create employees table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
	return_id VARCHAR(255) PRIMARY KEY,
    issued_id VARCHAR(255),   -- FK
    return_date DATE,
    book_condition VARCHAR(255)
);




-- add constraints
ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (emp_branch_id)
REFERENCES branch(branch_id);


ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_member_id FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
ADD CONSTRAINT fk_issued_emp_id FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
ADD CONSTRAINT fk_issued_book_isbn FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn);
    

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id FOREIGN KEY (issued_id) REFERENCES issued_status(issued_id);
    