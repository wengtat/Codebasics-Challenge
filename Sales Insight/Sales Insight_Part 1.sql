-- To see how many total sales transaction
SELECT count(*) FROM sales.transactions as Sales_Count;

-- To see number of records in customer table
 SELECT count(*) FROM sales.customers as Customer_Count; 

-- To see number of transaction from ‘Chennai’
SELECT count(*) FROM sales.transactions 
WHERE market_code IN 
	(SELECT markets_code FROM sales.markets
	WHERE markets_name = 'Chennai');

-- Find number of transactions in USD currency
SELECT count(*) FROM sales.transactions
WHERE currency = 'USD';

-- Find number of records in year 2020
-- Method 1
SELECT count(*) FROM sales.transactions
WHERE YEAR(order_date) = 2020;

-- Method 2
SELECT count(*) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2020;

-- Find sum of sales in year 2020
SELECT SUM(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2020;

-- Find sum of sales in year 2019
SELECT SUM(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2019;

-- Observation: Sales revenue declining from year 2019 to 2020
-- Find sum of sales in year 2020 from Chennai
SELECT SUM(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2020 AND T.market_code = 'Mark001';

-- Find distinct product code from Chennai
SELECT distinct product_code FROM sales.transactions where market_code='Mark001';

