create database join_groupby_where;
use join_groupby_where;


CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    contact_email VARCHAR(100)
);

INSERT INTO clients (client_name, contact_person, contact_email) VALUES
('TechCorp', 'Alice Brown', 'alice.brown@techcorp.com'),
('MarketSolutions', 'David Green', 'david.green@marketsolutions.com'),
('FinancePros', 'Evelyn White', 'evelyn.white@financepros.com'),
('HRInnovations', 'Michael Black', 'michael.black@hrinnovations.com'),
('EduLearn', 'Linda Blue', 'linda.blue@edulearn.com');


CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    amount DECIMAL(15, 2) NOT NULL,
    invoice_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

INSERT INTO invoices (client_id, amount, invoice_date, status) VALUES
(1, 15000.00, '2023-05-01', 'Paid'),
(2, 25000.00, '2023-04-15', 'Unpaid'),
(3, 10000.00, '2023-03-20', 'Paid'),
(4, 18000.00, '2023-02-10', 'Unpaid'),
(5, 22000.00, '2023-01-25', 'Paid');


CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    payment_date DATE,
    amount DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);

INSERT INTO payments (invoice_id, payment_date, amount) VALUES
(1, '2023-05-02', 15000.00),
(3, '2023-03-21', 10000.00),
(5, '2023-01-26', 22000.00);


-- Advance Questions 

-- Q1) List all clients along with the total amount of their invoices.
SELECT 
    c.client_name, SUM(i.amount) AS Total_Invices_Amount
FROM
    clients AS c
        JOIN
    invoices AS i ON c.client_id = i.client_id
GROUP BY c.client_name;

-- Q2) Find the total number of paid and unpaid invoices for each client.
SELECT 
    c.client_name,
    i.status,
    COUNT(i.invoice_id) AS Total_of_P_UP
FROM
    clients AS c
        JOIN
    invoices AS i ON c.client_id = i.client_id
GROUP BY i.status , c.client_name;

 -- Q3) Get the total amount of payments received for each client.
SELECT 
    c.client_name, SUM(p.amount) AS total_received_amount
FROM
    clients AS c
        JOIN
    invoices AS i ON c.client_id = i.client_id
        JOIN
    payments AS p ON i.invoice_id = p.invoice_id
GROUP BY c.client_name;

-- Q4) List all invoices with their status and the corresponding client’s contact person.
SELECT 
    i.invoice_id, i.amount, i.status, c.contact_person
FROM
    invoices AS i
        JOIN
    clients AS c ON i.client_id = c.client_id;

-- Q5) Find the average invoice amount for each client.
SELECT 
    c.client_name AS client_name,
    ROUND(AVG(i.amount), 1) AS avg_amount
FROM
    clients AS c
        JOIN
    invoices AS i ON c.client_id = i.client_id
GROUP BY client_name;

-- Q6) Get the total number of payments made for each invoice.
SELECT 
    i.invoice_id AS inv_id, COUNT(p.amount)
FROM
    invoices AS i
        JOIN
    payments AS p ON i.invoice_id = p.invoice_id
GROUP BY inv_id;

-- Q7) Find clients who have unpaid invoices.
SELECT 
    c.client_name, i.status
FROM
    clients AS c
        JOIN
    invoices AS i ON c.client_id = i.client_id
WHERE
    i.status = 'unpaid';


-- Q8) List all invoices with the total amount of payments received for each.
SELECT 
    i.invoice_id, i.amount, SUM(p.amount)
FROM
    invoices AS i
        JOIN
    payments AS p ON i.invoice_id = p.invoice_id
GROUP BY i.invoice_id;

-- Q9) Find the clients who have paid invoices in the last 6 months.
SELECT DISTINCT
    c.client_name AS client_name, p.payment_date AS payment_date
FROM
    clients AS c
        JOIN
    invoices AS i ON c.client_id = i.client_id
        JOIN
    payments AS p ON i.invoice_id = p.invoice_id
WHERE
    payment_date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- Q10) Get the number of invoices and their total amount for each client.
select c.client_name as client_name, i.invoice_id as invoice_id, sum(i.amount) as total_amount
from clients as c
join invoices as i
on c.client_id = i.client_id 
group by client_name, invoice_id;


