-- Query 1
DROP DATABASE IF EXISTS scenario2;
CREATE DATABASE scenario2;
USE scenario2;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (student_id)
) AUTO_INCREMENT = 2001;

CREATE TABLE memberships (
    membership_id INT AUTO_INCREMENT NOT NULL,
    student_id INT NOT NULL,
    PRIMARY KEY (membership_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) AUTO_INCREMENT = 101;

CREATE TABLE books (
    book_id INT AUTO_INCREMENT NOT NULL,
    book_name VARCHAR(100) NOT NULL,
    book_author VARCHAR(50) NOT NULL,
    PRIMARY KEY (book_id),
    UNIQUE (book_name)
) AUTO_INCREMENT = 501;

CREATE TABLE issues (
    issue_id INT AUTO_INCREMENT NOT NULL,
    issue_date DATE NOT NULL,
    membership_id INT NOT NULL,
    book_id INT NOT NULL,
    PRIMARY KEY (issue_id),
    FOREIGN KEY (membership_id) REFERENCES memberships (membership_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books (book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) AUTO_INCREMENT = 1501;

-- Query 2
INSERT INTO students (student_name)
VALUES ("Abhinabhas Patel"),("Ranya Kumar"),
       ("Charu Ismail"),("Sumati Ismail"),
       ("Eshika Singh"),("Aboil Khan"),
       ("Saurabh Kumar"),("Nidra Raj"),
       ("Shanta Ismail"),("Lipika Kumar"),
       ("Marisa Raj"),("Nabhya Singh"),
       ("Kundanika Raj"),("Prasata Jain"),("Shrivalli Khan");
       
INSERT INTO memberships (student_id)
VALUES (2001),(2002),(2003),(2004),
       (2005),(2006),(2008),(2009),
       (2010),(2013),(2014),(2015);
       
INSERT INTO books (book_name, book_author)
VALUES ('David Copperfield','Ralph Waldo Emerson'),
       ('Robinson Crusoe','Danielle Steel'),
       ('Moby Dick','J. K. Rowling'),
       ('Gone With the Wind','J. K. Rowling'),
       ('Oedipus at Colonus','Robert Frost'),
       ('Anna Karenina','Jules Verne'),
       ('Les Misérables','Flannery Connor'),
       ('The Brothers Karamazov ','William Shakespeare'),
       ('Wuthering Heights','William Faulkner'),
       ('The Magic Mountain','Jane Austen');

INSERT INTO issues (issue_date, membership_id, book_id)
VALUES ("2020-05-10",112,502),("2020-05-10",111,504),
       ("2020-05-10",111,510),("2020-05-10",111,505),
       ("2020-05-11",110,503),("2020-05-11",108,510),
       ("2020-05-11",103,508),("2020-05-12",107,507),
       ("2020-05-12",111,510),("2020-05-14",102,507),
       ("2020-05-14",102,505),("2020-05-14",106,509),
       ("2020-05-15",112,509),("2020-05-18",107,510),
       ("2020-05-18",106,508),("2020-05-18",112,507),
       ("2020-05-19",101,508),("2020-05-19",109,505),
       ("2020-05-20",102,506),("2020-05-20",104,510);

-- Query 3   
SELECT
    student_name,
    IFNULL(membership_id, 'None') AS membership_id
FROM
    students
        LEFT JOIN
    memberships USING (student_id);

-- Query 4
SELECT
    issue_id,
    issue_date,
    student_name,
    book_name
FROM
    issues
        INNER JOIN
    memberships USING (membership_id)
        INNER JOIN
    students USING (student_id)
        INNER JOIN
    books USING (book_id)
WHERE issue_date = CURRENT_DATE
ORDER BY issue_date;

-- Query 5
SELECT
    issue_id,
    student_name,
    book_name,
    book_author
FROM
    issues
        INNER JOIN
    books USING (book_id)
        INNER JOIN
    memberships USING (membership_id)
        INNER JOIN
    students USING (student_id)
WHERE book_author = 'J. K. Rowling'
ORDER BY issue_id;

-- Query 6
SELECT
    student_id,
    student_name,
    CASE
        WHEN issue_id IS NULL THEN 0
        ELSE COUNT(issue_id)
    END AS books_toll
FROM
    issues
        RIGHT JOIN
    memberships USING (membership_id)
        RIGHT JOIN
    students USING (student_id)
GROUP BY student_id;

-- Query 7
SELECT 
    issue_id,
    issue_date,
    book_name,
    book_author
FROM
    issues
        INNER JOIN
    memberships USING (membership_id)
        INNER JOIN
    books USING (book_id)
        INNER JOIN
    students USING (student_id)
WHERE student_id = 2014;

-- Query 8
SELECT 
    book_id,
    book_name,
    book_author,
    COUNT(issue_id) AS copies_sold
FROM
    issues
        INNER JOIN
    books USING (book_id)
GROUP BY book_id
ORDER BY copies_sold DESC;

-- Query 9
CREATE VIEW issues_data AS
    SELECT 
        issue_id, issue_date, student_name, book_name
    FROM
        issues
            INNER JOIN
        memberships USING (membership_id)
            INNER JOIN
        students USING (student_id)
            INNER JOIN
        books USING (book_id)
    ORDER BY issue_id;

-- Query 10
CREATE VIEW issues_analysis AS
    SELECT 
        issue_date,
        DAYNAME(issue_date) AS day_name,
        COUNT(book_id) AS books_sold
    FROM
        issues
    WHERE
        issue_date > DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
    GROUP BY issue_date;
