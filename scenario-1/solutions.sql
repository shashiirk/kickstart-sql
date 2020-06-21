-- Query 1
DROP DATABASE IF EXISTS scenario1;
CREATE DATABASE scenario1;
USE scenario1;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE items (
    item_id INT AUTO_INCREMENT NOT NULL,
    item_name VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    PRIMARY KEY (item_id),
    UNIQUE (item_name)
);

CREATE TABLE sales (
    bill_no INT AUTO_INCREMENT NOT NULL,
    bill_date TIMESTAMP NOT NULL,
    customer_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (bill_no),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items (item_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Query 2
INSERT INTO customers (customer_name)
VALUES ("Achyut"),("Vikranta"),("Devaraj"),
       ("Adinath"),("Lakshmibanta"),("Chandraprakash"),
       ("Samudragupta"),("Abhijat"),("Sananda"),("Urmila");
       
INSERT INTO items (item_name, price)
VALUES ("Sharpner", 5),("Pencil", 3),
       ("Eraser", 4),("Short Scale", 10),
       ("Long Scale", 20),("Note book", 30),
       ("Pad", 75),("Fevicol", 25),
       ("Color tape", 15),("Scissors", 50);

INSERT INTO sales (bill_date, customer_id, item_id, quantity)
VALUES ("2020-05-16 08:13:41",7,5,5),("2020-05-13 14:20:12",1,2,5),
       ("2020-05-13 19:21:17",2,6,3),("2020-05-17 12:11:08",2,5,5),
       ("2020-05-16 22:58:42",7,2,1),("2020-05-19 21:48:48",5,5,5),
       ("2020-05-18 06:58:14",5,2,5),("2020-05-19 18:52:31",5,6,2),
       ("2020-05-18 10:48:11",1,4,5),("2020-05-18 20:26:59",8,2,5),
       ("2020-05-18 16:29:39",4,2,3),("2020-05-10 01:35:38",2,4,4),
       ("2020-05-11 08:35:02",6,8,4),("2020-05-16 17:43:39",8,5,3),
       ("2020-05-17 04:36:50",2,3,2),("2020-05-16 08:14:38",5,7,5),
       ("2020-05-19 00:15:13",5,6,2),("2020-05-14 13:17:39",5,3,1),
       ("2020-05-18 19:50:15",8,6,2),("2020-05-19 13:38:47",6,4,2),
       ("2020-05-18 22:49:11",1,3,1),("2020-05-17 20:38:02",8,5,3),
       ("2020-05-15 15:53:48",8,6,4),("2020-05-12 09:31:15",8,5,2),
       ("2020-05-18 18:16:44",8,2,4),("2020-05-10 01:05:49",3,2,5),
       ("2020-05-14 19:12:58",5,6,2),("2020-05-10 18:39:03",3,7,4),
       ("2020-05-18 00:08:43",6,3,4),("2020-05-11 10:16:00",6,7,5);

-- Query 3
SELECT
    bill_no,
    DATE(bill_date) AS date,
    customer_name AS customer,
    item_id
FROM
    sales
        INNER JOIN
    items USING (item_id)
        INNER JOIN
    customers USING (customer_id)
WHERE DATE(bill_date) = DATE(NOW());

-- Query 4
SELECT
    bill_no,
    DATE(bill_date) AS date,
    customer_name AS customer,
    item_name AS item,
    price AS unit_price,
    quantity,
    (price * quantity) AS total_bill
FROM
    sales
        INNER JOIN
    items USING (item_id)
        INNER JOIN
    customers USING (customer_id)
ORDER BY date;

-- Query 5
SELECT
    customer_id,
    customer_name AS customer,
    item_id,
    price AS unit_price
FROM
    sales
        INNER JOIN
    items USING (item_id)
        INNER JOIN
    customers USING (customer_id)
WHERE price > 20
ORDER BY customer_id;

-- Query 6
SELECT
    customer_id,
    customer_name AS customer,
    COUNT(item_id) AS items_toll
FROM
    customers
        LEFT JOIN
    sales USING (customer_id)
GROUP BY customer_id
ORDER BY customer_id;

-- Query 7
SELECT
    customer_id,
    bill_no,
    item_name
FROM
    sales
        INNER JOIN
    items USING (item_id)
WHERE customer_id = 5;

-- Query 8
SELECT
    item_name,
    COUNT(customer_id) AS sold_toll
FROM
    sales
        RIGHT JOIN
    items USING (item_id)
GROUP BY item_id
ORDER BY sold_toll DESC;

-- Query 9
CREATE VIEW all_bills AS
    SELECT 
        bill_no,
        DATE(bill_date) AS date,
        TIME(bill_date) AS time,
        customer_id,
        item_id,
        price AS unit_price,
        quantity,
        (price * quantity) AS amount
    FROM
        sales
            INNER JOIN
        items USING (item_id)
    ORDER BY bill_no;

-- Query 10
CREATE VIEW week_analysis AS
    SELECT 
        DATE(bill_date) AS billed_date,
        DAYNAME(bill_date) AS day_name,
        SUM((price * quantity)) AS amount
    FROM
        sales
            INNER JOIN
        items USING (item_id)
    GROUP BY billed_date
    HAVING billed_date > DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    ORDER BY billed_date;
