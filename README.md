# plsql_window_functions_27995_ntwari
Ntwari Rutabingwa Simplice 27995 
 
STEP 1: Problem Definition 
Business Context
Company Type: Retail Electronics Company
 Department: Sales & Marketing Department
 Industry: Consumer Electronics Retail
Data Challenge
The company stores customer, product, and sales transaction data in separate tables. Management lacks integrated analytical reports to understand customer behavior, product performance, and monthly sales trends across regions.
Expected Outcome
The analysis will provide insights into top-performing products, customer segments, and sales growth trends to support strategic decisions such as inventory planning, marketing campaigns, and customer retention strategies.

STEP 2: Success Criteria (Window Function Goals)

Identify Top 5 products per region using RANK()
Calculate running monthly sales totals using SUM() OVER()
Measure month-over-month sales growth using LAG()
Segment customers into quartiles using NTILE(4)
Compute three-month moving averages using AVG() OVER()

STEP 3: Database Schema Design

STEP 4: Part A SQL JOINs Implementation
1. INNER JOIN – Valid transactions
SELECT c.customer_name, p.product_name, s.total_amount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id;

Business Interpretation:
 This query retrieves only transactions with valid customers and products. It helps management analyze confirmed sales records for revenue reporting.
2. LEFT JOIN – Customers with no transactions
SELECT c.customer_name, s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
Business Interpretation:
 This query identifies customers who have never made a purchase. These customers can be targeted with promotions or loyalty programs.
3. RIGHT JOIN – Products with no sales
SELECT p.product_name, s.sale_id
FROM sales s
RIGHT JOIN products p ON s.product_id = p.product_id
WHERE s.sale_id IS NULL;
Business Interpretation:
This shows products that have never been sold. Management may discontinue or promote these products.
4. FULL OUTER JOIN – Customers and Products including unmatched
SELECT c.customer_name, p.product_name, s.sale_id
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id
FULL OUTER JOIN products p ON s.product_id = p.product_id;
Business Interpretation:
This query compares customers and products including unmatched records, giving a complete picture of missing relationships.
5. SELF JOIN – Customers in the same region
SELECT a.customer_name AS customer1, b.customer_name AS customer2, a.region
FROM customers a
JOIN customers b
ON a.region = b.region
AND a.customer_id <> b.customer_id;
Business Interpretation:
This compares customers within the same region to analyze regional patterns and customer clusters.

STEP 5: Part B  Window Functions Implementation
1. Ranking Functions
SELECT product_id, SUM(total_amount) AS revenue,
RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_products
FROM sales
GROUP BY product_id;
Interpretation:
Ranks products by total revenue to identify top-performing items.
2. Aggregate Window Functions
SELECT start_date, total_amount,
SUM(total_amount) OVER (ORDER BY start_date 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue
FROM rentals;

Interpretation:
Displays cumulative rental revenue over time to track business growth.
3. Navigation Functions (Month-over-month growth)
SELECT start_date, total_amount,
LAG(total_amount) OVER (ORDER BY start_date) AS previous_revenue,
(total_amount - LAG(total_amount) OVER (ORDER BY start_date)) AS growth
FROM rentals;
Interpretation:
 Compares current rental revenue with the previous period to measure growth or decline.
4. Distribution Functions (Customer segmentation)
SELECT customer_id, SUM(total_amount) AS total_spent,
NTILE(4) OVER (ORDER BY SUM(total_amount) DESC) AS customer_quartile
FROM rentals
GROUP BY customer_id;
Interpretation:
Segments customers into four groups based on spending behavior (VIP to low spenders).

 STEP 7: Results Analysis
Descriptive (What happened?)
The company generated most revenue from certain cars and apartments, while some properties had no rental activity. Customer spending varied significantly.
Diagnostic (Why did it happen?)
High-performing properties are located in high-demand areas and priced competitively. Low-performing properties suffer from poor location or low visibility.
Prescriptive (What should be done?)
The company should promote high-performing properties, revise prices for unused properties, and introduce loyalty programs for top customers.

STEP 8: Integrity Statement (for README)
I hereby declare that this project is my original work and was completed independently in accordance with academic integrity policies.

STEP 9: References
Oracle SQL Window Functions Documentation
PostgreSQL JOIN Documentation
W3Schools SQL Tutorial
INSY 8311 Lecture Notes












