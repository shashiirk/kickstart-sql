-- Query 1
DROP DATABASE IF EXISTS scenario5;
CREATE DATABASE scenario5;
USE scenario5;

CREATE TABLE classes (
    class_id INT NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (class_id),
    UNIQUE (class_name)
);

CREATE TABLE labs (
    lab_id INT NOT NULL,
    lab_name VARCHAR(50) NOT NULL,
    class_id INT NOT NULL,
    PRIMARY KEY (lab_id),
    UNIQUE (lab_name),
    FOREIGN KEY (class_id) REFERENCES classes (class_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    class_id INT NOT NULL,
    PRIMARY KEY (student_id),
    FOREIGN KEY (class_id) REFERENCES classes (class_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE allotments (
    student_id INT  NOT NULL,
    lab_id INT NOT NULL,
    day_of_week CHAR(3) NOT NULL,
    PRIMARY KEY (student_id, lab_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (lab_id) REFERENCES labs (lab_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Trigger
DELIMITER $$
CREATE TRIGGER before_allotmens_insert
    BEFORE INSERT
    ON allotments FOR EACH ROW
BEGIN
    DECLARE students_class_id, labs_class_id INT;
    DECLARE error_message VARCHAR(100);
    SET error_message = CONCAT('Invalid lab_id for student_id ', NEW.student_id);
    SELECT class_id INTO students_class_id
    FROM students
    WHERE student_id = NEW.student_id;
    SELECT class_id INTO labs_class_id
    FROM labs
    WHERE lab_id = NEW.lab_id;
    IF students_class_id <> labs_class_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = error_message;
    END IF;
END $$
DELIMITER ;

-- Query 2
INSERT INTO classes (class_id, class_name)
VALUES (101, 'Computer Science'),
       (102, 'Electrical & Electronics'),
       (103, 'Mechanical');
       
INSERT INTO labs (lab_id, lab_name, class_id)
VALUES (201, 'Java Programming Lab', 101),
       (202, 'Python Programming Lab', 101),
       (203, 'Microcontrollers Lab', 102),
       (204, 'Induction Machines Lab', 102),
       (205, 'Fluid Mechanics Lab', 103),
       (206, 'Thermodynamics Lab', 103);

INSERT INTO students (student_name, class_id)
VALUES ("Darpanika Khan",101),("Ashok Raj",101),
       ("Satyavati Khan",101),("Radhani Raj",101),
       ("Kakali Singh",101),("Krishanu Raj",101),
       ("Nartan Jain",101),("Akmal Khan",101),
       ("Triya Patel",101),("Snigdha Kumar",101),
       ("Sunandini Khan",102),("Amla Ismail",102),
       ("Kokila Jain",102),("Shamindra Kumar",102),
       ("Seemanti Jain",102),("Hetal Patel",102),
       ("Nirupama Raj",102),("Saguna Kumar",102),
       ("Gayatri Raj",102),("Marudham Raj",102),
       ("Priyam Ismail",103),("Shamshu Patel",103),
       ("Dhinanta Patel",103),("Jaidev Kumar",103),
       ("Krupa Singh",103),("Simran Singh",103),
       ("Agniprava Ismail",103),("Pugal Raj",103),
       ("Heer Khan",103),("Chirantan Singh",103);
        
INSERT INTO allotments (student_id, lab_id, day_of_week)
VALUES (1, 201, 'MON'),(2, 201, 'MON'),
       (3, 201, 'MON'),(4, 201, 'MON'),
       (5, 201, 'MON'),(6, 202, 'MON'),
       (7, 202, 'MON'),(8, 202, 'MON'),
       (9, 202, 'MON'),(10, 202, 'MON'),
       (1, 202, 'TUE'),(2, 202, 'TUE'),
       (3, 202, 'TUE'),(4, 202, 'TUE'),
       (5, 202, 'TUE'),(6, 201, 'TUE'),
       (7, 201, 'TUE'),(8, 201, 'TUE'),
       (9, 201, 'TUE'),(10, 201, 'TUE'),
       (11, 203, 'WED'),(12, 203, 'WED'),
       (13, 203, 'WED'),(14, 203, 'WED'),
       (15, 203, 'WED'),(16, 204, 'WED'),
       (17, 204, 'WED'),(18, 204, 'WED'),
       (19, 204, 'WED'),(20, 204, 'WED'),
       (11, 204, 'THU'),(12, 204, 'THU'),
       (13, 204, 'THU'),(14, 204, 'THU'),
       (15, 204, 'THU'),(16, 203, 'THU'),
       (17, 203, 'THU'),(18, 203, 'THU'),
       (19, 203, 'THU'),(20, 203, 'THU'),
       (21, 205, 'FRI'),(22, 205, 'FRI'),
       (23, 205, 'FRI'),(24, 205, 'FRI'),
       (25, 205, 'FRI'),(26, 206, 'FRI'),
       (27, 206, 'FRI'),(28, 206, 'FRI'),
       (29, 206, 'FRI'),(30, 206, 'FRI'),
       (21, 206, 'SAT'),(22, 206, 'SAT'),
       (23, 206, 'SAT'),(24, 206, 'SAT'),
       (25, 206, 'SAT'),(26, 205, 'SAT'),
       (27, 205, 'SAT'),(28, 205, 'SAT'),
       (29, 205, 'SAT'),(30, 205, 'SAT');

-- Query 3      
SELECT
    student_id,
    student_name,
    class_name,
    lab_name,
    day_of_week AS allotment_day
FROM
    allotments
        INNER JOIN
    students USING (student_id)
        INNER JOIN
    classes USING (class_id)
        INNER JOIN
    labs USING (lab_id);

-- Query 4
SELECT
    day_of_week,
    COUNT(DISTINCT lab_id) AS labs_toll,
    COUNT(student_id) AS students_toll
FROM allotments
GROUP BY day_of_week;

-- Query 5
SELECT
    COUNT(lab_id) AS CS_labs_toll
FROM
    labs
        INNER JOIN
    classes USING (class_id)
GROUP BY class_name
HAVING class_name = 'computer science';

-- Query 6
SELECT
    student_id,
    student_name,
    class_name,
    lab_name,
    day_of_week AS allotment_day
FROM
    allotments
        INNER JOIN
    students USING (student_id)
        INNER JOIN
    classes USING (class_id)
        INNER JOIN
    labs USING (lab_id)
WHERE student_id = 5;

-- Query 7
SELECT 
    lab_id, lab_name,
    COUNT(student_id) AS students_toll
FROM
    allotments
        INNER JOIN
    labs USING (lab_id)
GROUP BY lab_id
ORDER BY lab_id;

-- Query 8
SELECT
    class_id,
    class_name,
    COUNT(student_id) AS students_in_labs
FROM
    allotments
        INNER JOIN
    labs USING (lab_id)
        INNER JOIN
    classes USING (class_id)
GROUP BY class_id;

-- Query 9
CREATE VIEW lab_allotments AS
    SELECT 
        student_id,
        student_name,
        class_id,
        lab_id,
        day_of_week AS allotment_day
    FROM
        allotments
            INNER JOIN
        students USING (student_id);

-- Query 10
CREATE VIEW thursday_labs AS
    SELECT DISTINCT
        day_of_week, lab_name
    FROM
        allotments
            INNER JOIN
        labs USING (lab_id)
    WHERE
        day_of_week = 'THU';
