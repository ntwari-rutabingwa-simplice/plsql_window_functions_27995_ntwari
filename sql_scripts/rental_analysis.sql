CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  phone VARCHAR(20),
  region VARCHAR(50)
);
CREATE TABLE properties (
  property_id INT PRIMARY KEY,
  property_name VARCHAR(100),
  property_type VARCHAR(20), -- 'Car' or 'Apartment'
  location VARCHAR(50),
  daily_rate NUMBER(10,2)
);
CREATE TABLE rentals (
  rental_id INT PRIMARY KEY,
  customer_id INT,
  property_id INT,
  start_date DATE,
  end_date DATE,
  total_amount NUMBER(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
);
SELECT c.customer_name, p.property_name, p.property_type, r.total_amount
FROM rentals r
INNER JOIN customers c ON r.customer_id = c.customer_id
INNER JOIN properties p ON r.property_id = p.property_id;
SELECT c.customer_name, r.rental_id
FROM customers c
LEFT JOIN rentals r ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;
SELECT p.property_name, r.rental_id
FROM rentals r
RIGHT JOIN properties p ON r.property_id = p.property_id
WHERE r.rental_id IS NULL;
SELECT c.customer_name, p.property_name, r.rental_id
FROM customers c
FULL OUTER JOIN rentals r ON c.customer_id = r.customer_id
FULL OUTER JOIN properties p ON r.property_id = p.property_id;
SELECT a.customer_name AS customer1, b.customer_name AS customer2, a.region
FROM customers a
JOIN customers b
ON a.region = b.region
AND a.customer_id <> b.customer_id;
SELECT p.property_name, SUM(r.total_amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(r.total_amount) DESC) AS revenue_rank
FROM rentals r
JOIN properties p ON r.property_id = p.property_id
GROUP BY p.property_name;
SELECT start_date, total_amount,
SUM(total_amount) OVER (ORDER BY start_date 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue
FROM rentals;
SELECT start_date, total_amount,
LAG(total_amount) OVER (ORDER BY start_date) AS previous_revenue,
(total_amount - LAG(total_amount) OVER (ORDER BY start_date)) AS growth
FROM rentals;
SELECT customer_id, SUM(total_amount) AS total_spent,
NTILE(4) OVER (ORDER BY SUM(total_amount) DESC) AS customer_quartile
FROM rentals
GROUP BY customer_id;
