Sales insight project
Purpose: 
	To unlock sales insights that are not visible before
	Decision support for sales team 
	Automate them to reduce manual time spent in data gathering

Stakeholders
	Sales Director
	Marketing Team
	Customer Service Team
	Data Analytics Team
	IT

End Result
	An automated/interactive dashboard providing quick and latest sales insights in order to support data driven decision making
Success Criteria
	Dashboard uncovering sales order insights with latest data available.
	Sales team able to take better decisions & prove 10% cost savings of total spend
	Sales analyst stop data gathering manually in order to save 20% of their business time and reinvest in value added activity

Datasets
5 tables: 
	Customers: customer_code, customer_name, customer_type
	Date: date, cy_date, year, month_name, date_yy_mmm
	Markets: markets_code, markets_name, zone
	Products: product_code, product_type
	Transactions: product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency

Findings:
	Sales amounts contain negative figures.
	Empty zone
	Inconsistent currency


MySQL query
To see how many total sales transaction
SELECT count(*) FROM sales.transactions as Sales_Count;
Output: 150,283

To see number of records in customer table
 SELECT count(*) FROM sales.customers as Customer_Count; 
Output: 38

To see number of transaction from ‘Chennai’
SELECT count(*) FROM sales.transactions 
WHERE market_code IN 
	(SELECT markets_code FROM sales.markets
	WHERE markets_name = 'Chennai')
Output: 1035

Find number of transactions in USD currency
SELECT count(*) FROM sales.transactions
WHERE currency = 'USD'
Output: 2

Find number of records in year 2020
SELECT count(*) FROM sales.transactions
WHERE YEAR(order_date) = 2020
Output: 21550
Or
SELECT count(*) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2020
Output: 21550
Find sum of sales in year 2020
SELECT SUM(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2020
Output: 142,235,559

Find sum of sales in year 2019
SELECT SUM(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2019
Output: 336,452,114

Observation: Sales revenue declining from year 2019 to 2020
Find sum of sales in year 2020 from Chennai
SELECT SUM(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date D
ON T.order_date = D.date
WHERE D.year = 2020 AND T.market_code = ‘Mark001’
Output: 2,463,024

Find distinct product code from Chennai
SELECT distinct product_code FROM sales.transactions where market_code=’Mark001’


PERFORM ETL
	Load sales dataset between POWERBI & MySQL
	Load all 5 tables
	Data modelling
	Transform data > data cleaning > exclude zone under blank, exclude sales amount <= 0, convert all currency into INR by adding new conditional column ‘norm_sales_amount’

Findings: Noticed there are duplicates transactions
SELECT DISTINCT currency FROM sales.transactions;
-- 'INR'
-- 'USD'
-- 'INR\r'
-- 'USD\r'
SELECT COUNT(*) FROM sales.transactions WHERE currency = 'INR';
-- 279
SELECT COUNT(*) FROM sales.transactions WHERE currency = 'INR\r';
-- 150000
SELECT COUNT(*) FROM sales.transactions WHERE currency = 'USD';
-- 2
SELECT COUNT(*) FROM sales.transactions WHERE currency = 'USD\r'
-- 2

To remove duplicates from PowerQuery

Preparing Dashboard
Check total revenue
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE T.currency = 'INR\r' or T.currency = 'USD\r'
Output: 984,813,462

Check revenue in year 2020
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND T.currency = 'INR\r' or T.currency = 'USD\r'
Output: 142,225,295
Check total sales quantity
SELECT sum(T.sales_qty) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND T.currency = 'INR\r' or T.currency = 'USD\r'
Output: 352,280

List revenue by customers, order by desc
SELECT T.customer_code, sum(T.sales_amount) as Total FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE T.currency = 'INR\r' or T.currency = 'USD\r'
GROUP BY T.customer_code
ORDER BY Total DESC

List sales_qty by customers, order by desc
SELECT T.customer_code, sum(T.sales_amount) as Total FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE T.currency = 'INR\r' or T.currency = 'USD\r'
GROUP BY T.customer_code
ORDER BY Total DESC

Check total sales in Jan 2020
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND d.month_name = 'January' AND (T.currency = 'INR\r' or T.currency = 'USD\r')
Output: 25,656,567

Check total sales in year 2020 by market name ‘Chennai’
SELECT sum(T.sales_amount) FROM sales.transactions T
INNER JOIN sales.date d
ON T.order_date = d.date
WHERE d.year = 2020 AND T.market_code = 'Mark001' AND (T.currency = 'INR\r' or T.currency = 'USD\r')
Output: 2,463,024
