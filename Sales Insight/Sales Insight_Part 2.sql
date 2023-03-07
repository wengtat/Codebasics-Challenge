-- Preparing Dashboard
-- Check total revenue
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE T.currency = 'INR\r' or T.currency = 'USD\r';

-- Check revenue in year 2020
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND T.currency = 'INR\r' or T.currency = 'USD\r';

-- Check total sales quantity
SELECT sum(T.sales_qty) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND T.currency = 'INR\r' or T.currency = 'USD\r';

-- List revenue by customers, order by desc
SELECT T.customer_code, sum(T.sales_amount) as Total FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE T.currency = 'INR\r' or T.currency = 'USD\r'
GROUP BY T.customer_code
ORDER BY Total DESC;

-- List sales_qty by customers, order by desc
SELECT T.customer_code, sum(T.sales_amount) as Total FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE T.currency = 'INR\r' or T.currency = 'USD\r'
GROUP BY T.customer_code
ORDER BY Total DESC;

-- Check total sales in Jan 2020
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND d.month_name = 'January' AND (T.currency = 'INR\r' or T.currency = 'USD\r');

-- Check total sales in year 2020 by market name ‘Chennai’
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND T.market_code = 'Mark001' AND (T.currency = 'INR\r' or T.currency = 'USD\r')

