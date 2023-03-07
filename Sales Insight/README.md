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
