-- Codebasics challenge
	-- 1.Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
SELECT DISTINCT market FROM gdb023.dim_customer C
WHERE region = 'APAC' AND customer = 'Atliq Exclusive';

	-- 2.What is the percentage of unique product increase in 2021 vs. 2020? 
	-- The final output contains these fields, unique_products_2020 unique_products_2021 percentage_chg
	-- Step 1: To calculate the count of unique product in year 2021 --245
	-- Step 2: To calculate the count of unique product in year 2020 -- 334
with cte1 as (SELECT COUNT(DISTINCT(S.product_code)) as 'unique_products_2020'
	FROM gdb023.fact_sales_monthly S
	WHERE S.fiscal_year = '2020'),

	cte2 as (SELECT COUNT(DISTINCT(S.product_code)) as 'unique_products_2021'
	FROM gdb023.fact_sales_monthly S
	WHERE S.fiscal_year = '2021')

SELECT  *,
		ROUND((unique_products_2021/unique_products_2020 -1)*100,2) AS percentage_chg
FROM cte2 
CROSS JOIN cte1;

	-- 3.Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. The final output contains 2 fields: segment & product_count
		-- Step 1: To check the total distinct product count for all segment -- 397
		-- Step 2: To count distinct product group by segment

SELECT count(distinct product_code)
FROM gdb023.dim_product;

SELECT segment,
		count(distinct product_code) as product_count
FROM gdb023.dim_product
GROUP BY segment
ORDER BY product_count DESC;

	-- 4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields: segment, product_count_2020, product_count_2021, difference
with cte1 as (SELECT distinct P.segment,
					COUNT(DISTINCT(S.product_code)) as 'product_count_2020'
			FROM gdb023.fact_sales_monthly S
			LEFT JOIN gdb023.dim_product P
			ON S.product_code = P.product_code
			WHERE S.fiscal_year = '2020'
			GROUP BY P.segment),

	cte2 as (SELECT distinct P.segment,
					COUNT(DISTINCT(S.product_code)) as 'product_count_2021'
			FROM gdb023.fact_sales_monthly S
			LEFT JOIN gdb023.dim_product P
			ON S.product_code = P.product_code
			WHERE S.fiscal_year = '2021'
			GROUP BY P.segment)

SELECT  cte2.segment,
		cte1.product_count_2020,
        cte2.product_count_2021,
        abs(cte2.product_count_2021 - cte1.product_count_2020) as difference
FROM cte2 
INNER JOIN cte1
ON cte2.segment = cte1.segment
ORDER BY difference DESC;

-- Accessories segment has the most increase in unique products between year 2020 and 2021 at 34
    
-- 5. Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields: product_code, product, manufacturing_cost

 -- Products with highest manufacturing costs 
with cte1 as (SELECT M.product_code,
		P.product,
		M.manufacturing_cost
FROM gdb023.fact_manufacturing_cost M
LEFT JOIN gdb023.dim_product P
ON M.product_code = P.product_code
ORDER BY M.manufacturing_cost DESC
LIMIT 1),

-- Products with lowest manufacturing costs 
	cte2 as (SELECT M.product_code,
		P.product,
		M.manufacturing_cost
FROM gdb023.fact_manufacturing_cost M
LEFT JOIN gdb023.dim_product P
ON M.product_code = P.product_code
ORDER BY M.manufacturing_cost ASC
LIMIT 1)

SELECT *
FROM cte1
UNION 
SELECT *
FROM cte2;

-- 6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output contains these fields: customer_code, customer, average_discount_percentage

SELECT C.customer_code,
		C.customer,
		AVG(I.pre_invoice_discount_pct) as average_discount_percentage
FROM gdb023.fact_pre_invoice_deductions I
LEFT JOIN gdb023.dim_customer C
ON I.customer_code = C.customer_code
WHERE I.fiscal_year = '2021' AND C.market = 'India'
GROUP BY C.customer_code, C.customer
ORDER BY average_discount_percentage DESC
LIMIT 5;

-- 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month . This analysis helps to get an idea of low and high-performing months and take strategic decisions. The final report contains these columns: Month, Year, Gross sales Amount
SELECT 	monthname(S.date) as 'Month',
        year(S.date) as 'Year',
        ROUND(SUM(S.sold_quantity * G.gross_price),2) as Gross_sales_Amount
FROM gdb023.fact_sales_monthly S
LEFT JOIN gdb023.fact_gross_price G
ON S.product_code = G.product_code
AND S.fiscal_year = G.fiscal_year
LEFT JOIN gdb023.dim_customer C
ON S.customer_code = C.customer_code
WHERE C.customer = 'Atliq Exclusive'
GROUP BY C.customer, Month, Year
ORDER BY Year ASC;
                            

-- 8. In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity: Quarter, total_sold_quantity

with cte as (SELECT *,
			MONTH(date) as Month,
			CASE WHEN MONTH(date) IN (9,10,11) THEN 'Q1'
				 WHEN MONTH(date) IN (12,1,2) THEN 'Q2'
				 WHEN MONTH(date) IN (3,4,5) THEN 'Q3'
				 ELSE 'Q4' END as fiscal_quarter
			FROM gdb023.fact_sales_monthly   
			WHERE fiscal_year = 2020)

SELECT fiscal_quarter as Quarter,
		sum(sold_quantity) as total_sold_quantity
FROM cte
GROUP BY Quarter
ORDER BY total_sold_quantity DESC;

-- 9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields: channel, gross_sales_mln, percentage
with cte1 as (SELECT channel,
			SUM(S.sold_quantity * G.gross_price) as gross_sales_mln
			FROM gdb023.fact_sales_monthly S
			LEFT JOIN gdb023.fact_gross_price G
			ON S.product_code = G.product_code AND S.fiscal_year = G.fiscal_year
			LEFT JOIN gdb023.dim_customer C
			ON S.customer_code = C.customer_code
			WHERE S.fiscal_year = 2021
			GROUP BY channel)

SELECT *,
		ROUND(gross_sales_mln / sum(gross_sales_mln) over()*100,2) as percentage
FROM cte1
GROUP BY channel
ORDER BY percentage DESC;


-- 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these fields: division, product_code, product, total_sold_quantity, rank_order
with cte as (SELECT P.division,
			P.product_code,
			P.product,
			sum(S.sold_quantity) as total_sold_quantity,
			RANK()OVER(PARTITION BY P.division ORDER BY sum(S.sold_quantity) DESC) as rank_order
			FROM gdb023.fact_sales_monthly S
			LEFT JOIN gdb023.fact_gross_price G
			ON S.product_code = G.product_code AND S.fiscal_year = G.fiscal_year
			LEFT JOIN gdb023.dim_product P
			ON S.product_code = P.product_code
			WHERE S.fiscal_year = 2021
			GROUP BY P.division,P.product_code,P.product
			ORDER BY P.division, rank_order)

SELECT *
FROM cte
WHERE rank_order <= 3
