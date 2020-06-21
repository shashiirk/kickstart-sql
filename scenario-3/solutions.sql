-- Query 1
DROP DATABASE IF EXISTS scenario3;
CREATE DATABASE scenario3;
USE scenario3;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT NOT NULL,
    employee_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (employee_id)
);

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT NOT NULL,
    department_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (department_id)
);

CREATE TABLE paydetails (
    employee_id INT NOT NULL,
    department_id INT NOT NULL,
    basic_salary INT NOT NULL,
    deductions INT DEFAULT 0,
    additions INT DEFAULT 0,
    date_of_join DATE NOT NULL,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments (department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE payrolls (
    employee_id INT NOT NULL,
    pay_date DATE NOT NULL,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Query 2
INSERT INTO employees (employee_name)
VALUES ("Ashvin Kumar"),("Krithi Patel"),
       ("Rampratap Kumar"),("Suchira Kumar"),
       ("Faiyaz Khan"),("Raghu Khan"),
       ("Fateh Jain"),("Gopi Kumar"),
       ("Anandalakshmi Singh"),("Sunayana Singh");
       
INSERT INTO departments (department_name)
VALUES ("Tech Support"),
       ("Human Resources"),
       ("Accounting"),
       ("Customer Relations"),
       ("Sales and Marketing");

INSERT INTO paydetails (employee_id, department_id, basic_salary, deductions, additions, date_of_join)
VALUES (1,1,53000,730,1620,"2020/04/04"),
       (2,3,35200,0,7400,"2020/04/07"),
       (3,5,49800,2600,7800,"2020/04/09"),
       (4,4,47300,1500,7280,"2020/04/12"),
       (5,5,32200,3200,0,"2020/04/21"),
       (6,2,36100,2500,7020,"2020/04/27"),
       (7,1,73900,0,6500,"2020/04/29"),
       (8,3,68200,7700,2140,"2020/05/07"),
       (9,3,45700,5700,4470,"2020/05/13"),
       (10,3,40600,2220,0,"2020/05/20");
       
INSERT INTO payrolls (employee_id, pay_date)
VALUES (1, '2020/05/10'),
       (2, '2020/05/10'),
       (3, '2020/05/10'),
       (4, '2020/05/20'),
       (5, '2020/05/20'),
       (6, '2020/05/30'),
       (7, '2020/05/30'),
       (8, '2020/06/10'),
       (9, '2020/06/20'),
       (10, '2020/06/20');

-- Query 3      
SELECT
    employee_id,
    employee_name,
    department_name
FROM
    paydetails
        INNER JOIN
    departments USING (department_id)
        INNER JOIN
    employees USING (employee_id)
ORDER BY department_name, employee_id;

-- Query 4
SELECT
    employee_id,
    employee_name,
    department_id,
    date_of_join
FROM
    paydetails
        INNER JOIN
    employees USING (employee_id)
WHERE date_of_join > '2020-04-20';

-- Query 5
SELECT
    employee_id,
    employee_name,
    department_name,
    basic_salary
FROM
    paydetails
        INNER JOIN
    employees USING (employee_id)
        INNER JOIN
    departments USING (department_id)
WHERE basic_salary BETWEEN 30000 AND 45000;

-- Query 6
SELECT
    department_name,
    COUNT(employee_id) AS employees_toll
FROM
    paydetails
        INNER JOIN
    departments USING (department_id)
GROUP BY department_id
ORDER BY department_name;

-- Query 7
SELECT
    employee_id,
    employee_name,
    (basic_salary - deductions + additions) AS net_salary
FROM
    paydetails
        INNER JOIN
    employees USING (employee_id)
HAVING net_salary > 45000;

-- Query 8    
SELECT
    employee_id,
    employee_name,
    department_name,
    (basic_salary - deductions + additions) AS net_salary,
    date_of_join
FROM
    paydetails
        INNER JOIN
    departments USING (department_id)
        INNER JOIN
    employees USING (employee_id)
WHERE employee_id = 4;

-- Query 9
CREATE VIEW employee_details AS
    SELECT 
        employee_id,
        employee_name,
        department_name,
        basic_salary,
        deductions,
        additions,
        (basic_salary - deductions + additions) AS net_salary
    FROM
        paydetails
            INNER JOIN
        departments USING (department_id)
            INNER JOIN
        employees USING (employee_id)
    ORDER BY employee_id;

-- Query 10
CREATE VIEW employee_details2 AS
    SELECT 
        employee_id,
        employee_name,
        (basic_salary - deductions + additions) AS net_salary
    FROM
        paydetails
            INNER JOIN
        employees USING (employee_id);
