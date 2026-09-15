
--------SCHEMA NAME = superstoresales.

--Q1. List the top 10 customers by total sales amount. Show CustomerID, full name, and total sales.

with cte as (
select
	Top 10
	CustomerID,
	SUM(price) as Total_Sales_Amt
from superstoresales.sales S
group by S.customerID
order by Total_Sales_Amt desc) 

select
	C.id,
	C.firstname + C.lastname as full_name,
	T.Total_Sales_Amt
from superstoresales.customer C
inner join cte T
on C.id = T.customerID



--Q2. Show total sales per month for the year 2023, ordered by month.

select
	year(orderdate) as year,
	MONTH(orderdate) as month,
	SUM(price) as Total_Sales
from superstoresales.sales
where year(orderdate) = 2023
group by year(orderdate), MONTH(orderdate)
order by month asc



----------Q3. Find out the products that have never been sold

select
	P.productid,
	P.productname,
	S.*
from superstoresales.Products P
left join superstoresales.sales S
on S.productid = P.productid
where S.orderID is null




--Q4. Find how many new customers were acquired in 2022

select
	count(*) as new_customers
from (
	select
		customerid,
		year(min(orderdate)) as first_order_date
	from superstoresales.sales
	group by customerid
	having year(min(orderdate)) = 2022
) S


--Q5. Calculate the profit margin (Profit / Sales) percentage for each category.

select
	P.category,
	round(sum(S.profit) / sum(S.price) * 100, 2) as profit_margin
from superstoresales.sales S
inner join superstoresales.products P
on S.productid = P.productid
group by P.category



--Q6. For each category, show date-wise sales and a running total of sales over time.

select
	P.category,
	S.orderdate,
	S.price,
	SUM(S.price) OVER (
		PARTITION BY P.category
		ORDER BY S.orderdate
		ROWS BETWEEN unbounded preceding and current row
	) as running_total
from superstoresales.sales S
inner join superstoresales.products P
on S.productid = P.productid



-------Q7. Get the most recent order (by OrderDate) for every customer.

select
	CustomerID,
	max(OrderDate) as recent_order
from SuperstoreSales.Sales
group by CustomerID

--Q8. Classify customers based on their total sale. Show CustomerID, name, total sales: 
--Platinum – TotalSales ? 15,000
--Gold – 10,000 to < 15,000
--Silver – 5,000 to < 10,000
--Bronze – < 5,000

select
	C.ID,
	C.FirstName + C.LastName as full_name,
	sum(S.Price) as total_sales,
	CASE
		WHEN sum(S.Price) >= 15000 THEN 'Platinum'
		WHEN sum(S.Price) >= 10000 THEN 'Gold'
		WHEN sum(S.Price) >= 5000 THEN 'Silver'
		ELSE 'Bronze'
	END AS CustomerSegment
from SuperstoreSales.Sales S
inner join SuperstoreSales.Customer C
on S.CustomerID = C.ID
group by C.ID, C.FirstName, C.LastName


--Q9. For each category, find the product with the highest total sales. If ties exist, show all tied products.

with total_sales as (
	select
		P.Category,
		P.ProductName,
		SUM(S.price) as total_Sales
	from superstoresales.sales S
	inner join superstoresales.products P
	on S.productid = P.productid
	group by P.Category, P.ProductName
),
ranked_cte as (
	select
		*,
		DENSE_RANK() over (Partition by category order by total_sales desc) as ranked
	from total_sales
)
select
	*
from ranked_cte
where ranked = 1



--Q10. Actual vs Target sales by category & year


with cte as (
	select
		P.category,
		SUM(CASE WHEN YEAR(S.OrderDate) = 2020 THEN S.price ELSE 0 END) AS "2020_Actual_sales",
		SUM(CASE WHEN YEAR(S.OrderDate) = 2021 THEN S.price ELSE 0 END) AS "2021_Actual_sales",
		SUM(CASE WHEN YEAR(S.OrderDate) = 2022 THEN S.price ELSE 0 END) AS "2022_Actual_sales",
		SUM(CASE WHEN YEAR(S.OrderDate) = 2023 THEN S.price ELSE 0 END) AS "2023_Actual_sales"
	from superstoresales.sales S
	inner join superstoresales.products P
	on S.productid = P.productid
	group by P.Category
)


SELECT
	C.Category,
	T.[2020_Sales],
	C.[2020_Actual_sales],
	T.[2021_Sales],
	C.[2021_Actual_sales],
	T.[2022_Sales],
	C.[2022_Actual_sales],
	T.[2023_Sales],
	C.[2023_Actual_sales]
FROM SuperstoreSales.targetsales T
inner join cte C
on T.Category = C.Category
