-- Query 1
DROP DATABASE IF EXISTS scenario4;
CREATE DATABASE scenario4;
USE scenario4;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id)
) AUTO_INCREMENT = 5681;

CREATE TABLE memberships (
    membership_id INT AUTO_INCREMENT NOT NULL,
    customer_id INT NOT NULL,
    PRIMARY KEY (membership_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) AUTO_INCREMENT = 2541;

CREATE TABLE cassettes (
    cassette_id INT AUTO_INCREMENT NOT NULL,
    cassette_name VARCHAR(50) NOT NULL,
    cassette_language VARCHAR(50) NOT NULL,
    PRIMARY KEY (cassette_id),
    UNIQUE (cassette_name)
) AUTO_INCREMENT = 1501;

CREATE TABLE issues (
    issue_id INT AUTO_INCREMENT NOT NULL,
    issue_date DATE NOT NULL,
    membership_id INT NOT NULL,
    cassette_id INT NOT NULL,
    PRIMARY KEY (issue_id),
    FOREIGN KEY (membership_id) REFERENCES memberships (membership_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (cassette_id) REFERENCES cassettes (cassette_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Query 2
INSERT INTO customers (customer_name)
VALUES ("Achyut"),("Vikranta"),("Devaraj"),
       ("Adinath"),("Lakshmibanta"),("Chandraprakash"),
       ("Samudragupta"),("Abhijat"),("Sananda"),
       ("Rakesh"),("Simran"),("Urmila"),
       ("Megha"),("Bhuvan"),("Vignesh");

INSERT INTO memberships (customer_id)
VALUES (5681),(5682),(5683),
       (5684),(5686),(5687),
       (5688),(5689),(5690),
       (5693),(5694),(5695);
       
INSERT INTO cassettes (cassette_name, cassette_language)
VALUES ('Premikudu', 'Telugu'),
       ('Manoharudu', 'Telugu'),
       ('Freedom', 'English'),
       ('Aashiqui', 'Hindi'),
       ('Ranjhanaa', 'Hindi'),
       ('Konvicted', 'English'),
       ('Acheivers', 'English'),
       ('Cheliyaa', 'Telugu'),
       ('Villain', 'Hindi'),
       ('Gharshana', 'Telugu');
       
INSERT INTO issues (issue_date, membership_id, cassette_id)
VALUES ("2020/05/10",2548,1507),("2020/05/10",2552,1501),
       ("2020/05/11",2547,1504),("2020/05/11",2544,1501),
       ("2020/05/11",2549,1502),("2020/05/12",2552,1501),
       ("2020/05/12",2549,1509),("2020/05/13",2544,1510),
       ("2020/05/13",2550,1504),("2020/05/13",2544,1510),
       ("2020/05/13",2543,1505),("2020/05/14",2544,1505),
       ("2020/05/14",2549,1509),("2020/05/15",2549,1508),
       ("2020/05/15",2549,1501),("2020/05/16",2548,1502),
       ("2020/05/18",2541,1502),("2020/05/19",2541,1509),
       ("2020/05/19",2545,1502),("2020/05/20",2541,1503),
       ("2020/05/20",2547,1502),("2020/05/20",2542,1507),
       ("2020/05/20",2543,1505),("2020/05/20",2544,1510),
       ("2020/05/21",2543,1508);

-- Query 3
SELECT
    customer_id,
    customer_name,
    IFNULL(membership_id, 'None') AS membership_id
FROM
    memberships
        RIGHT JOIN
    customers USING (customer_id);

-- Query 4
SELECT
    issue_id,
    issue_date,
    customer_name,
    cassette_name
FROM
    issues
        INNER JOIN
    cassettes USING (cassette_id)
        INNER JOIN
    memberships USING (membership_id)
        INNER JOIN
    customers USING (customer_id)
WHERE issue_date = CURRENT_DATE;

-- Query 5
SELECT
    issue_id,
    customer_id,
    customer_name,
    cassette_name
FROM
    issues
        INNER JOIN
    cassettes USING (cassette_id)
        INNER JOIN
    memberships USING (membership_id)
        INNER JOIN
    customers USING (customer_id)
WHERE cassette_name = 'Manoharudu';

-- Query 6
SELECT 
    customer_id,
    customer_name,
    CASE
        WHEN membership_id IS NULL THEN 0
        ELSE CASE
                WHEN issue_id IS NULL THEN 0
                ELSE COUNT(issue_id)
            END
    END AS cassettes_toll
FROM
    issues
        RIGHT JOIN
    memberships USING (membership_id)
        RIGHT JOIN
    customers USING (customer_id)
GROUP BY customer_id;

-- Query 7
SELECT
    issue_id,
    issue_date,
    cassette_name,
    cassette_language
FROM
    issues
        INNER JOIN
    cassettes USING (cassette_id)
WHERE membership_id = 2541;

-- Query 8
SELECT
    cassette_id,
    cassette_name,
    cassette_language,
    COUNT(issue_id) AS cassettes_sold
FROM
    issues
        INNER JOIN
    cassettes USING (cassette_id)
GROUP BY cassette_id
ORDER BY cassettes_sold DESC;

-- Query 9
CREATE VIEW issues_data AS
    SELECT 
        issue_id, issue_date, customer_name, cassette_name
    FROM
        issues
            INNER JOIN
        cassettes USING (cassette_id)
            INNER JOIN
        memberships USING (membership_id)
            INNER JOIN
        customers USING (customer_id)
    ORDER BY issue_id;

-- Query 10
CREATE VIEW issues_analysis AS
    SELECT 
        issue_date,
        DAYNAME(issue_date) AS day_name,
        COUNT(issue_id) AS cassettes_sold
    FROM
        issues
    WHERE
        issue_date > DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
    GROUP BY issue_date;
