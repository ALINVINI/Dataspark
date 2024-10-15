1) To find total sale quantity and sale amount in USD for each product
SELECT 
    p.productname, 
    SUM(s.Quantity) AS totalsales,
    SUM(s.Quantity * p.upusd) AS revenueusd
FROM 
    projectspark.sales AS s
JOIN 
    projectspark.products AS p ON s.ProductKey = p.ProductKey
GROUP BY 
    p.productname
ORDER BY 
    totalsales DESC;
    
2)To find total sale quantity and sale amount in USD from every country 

SELECT 
    c.Country,
    SUM(s.Quantity) AS totalsales,
    SUM(s.Quantity * p.upusd) AS totalrevenueusd
FROM 
    projectspark.sales AS s
JOIN 
    projectspark.customers AS c ON s.CustomerKey = c.CustomerKey
JOIN 
    projectspark.products AS p ON s.ProductKey = p.ProductKey
GROUP BY 
    c.Country
ORDER BY 
    totalsales DESC;


3) To find products with zero sales 

SELECT 
    ProductKey, ProductName, Brand, Category
FROM 
    projectspark.products AS p
WHERE 
    p.ProductKey NOT IN (SELECT s.ProductKey FROM projectSpark.sales AS s);
    
4) To find number of orders with respect to purchase currency for all currencies

SELECT 
    s.CurrencyCode,
    COUNT(s.OrderNumber) AS TotalSales
FROM 
    projectspark.sales AS s
GROUP BY 
    s.CurrencyCode
ORDER BY 
    TotalSales DESC;

5) To find the months in which there is highest business

SELECT 
    MONTH(s.orderdate) AS Month,
    SUM(s.Quantity * p.upusd) AS totalrevenueusd
FROM 
    projectspark.sales AS s
JOIN 
    projectspark.products AS p ON s.ProductKey = p.ProductKey
GROUP BY 
    Month
ORDER BY 
    Month;
 
 6) To find the profit gained on each order

SELECT 
    s.Ordernumber ,
    (s.Quantity * p.upusd) - (s.Quantity * p.ucusd) AS Profit
FROM 
    projectspark.sales AS s
JOIN 
    projectspark.products AS p ON s.ProductKey = p.ProductKey;
    
7) To find the stores with zero revenue/sales

SELECT 
    s.StoreKey, s.State
FROM 
    Stores s
LEFT JOIN 
    Sales sa ON s.StoreKey = sa.StoreKey
WHERE 
    sa.StoreKey IS NULL;
    
    
 8) To find the whole business insights of each store(Profit, Revenue, no.of.orders, no.of.customers)   
     WITH SalesData AS (
    SELECT
        s.StoreKey,
        SUM(p.upusd * s.Quantity) AS TotalRevenue,
        SUM((p.upusd - p.ucusd) * s.Quantity) AS TotalProfit,
        COUNT(DISTINCT s.CustomerKey) AS NumberOfCustomers,
        COUNT(s.OrderNumber) AS NumberOfOrders
    FROM
        sales s
    JOIN
        products p ON s.ProductKey = p.ProductKey
    GROUP BY
        s.StoreKey
)
SELECT
    s.StoreKey,
    TotalRevenue,
    TotalProfit,
    NumberOfCustomers,
    NumberOfOrders
FROM
    SalesData s
JOIN
    stores st ON s.StoreKey = st.StoreKey
ORDER BY
    TotalRevenue DESC;



    
    8)To find the revenue generated from each category

SELECT
    p.CategoryKey,
    SUM((pr.upusd - pr.ucusd) * s.Quantity) AS ProfitUSD,
    SUM(pr.upusd * s.Quantity) AS RevenueUSD
FROM
    sales s
JOIN
    products pr ON s.ProductKey = pr.ProductKey
JOIN
    products p ON pr.CategoryKey = p.CategoryKey
GROUP BY
    p.CategoryKey;


10) To find the revenue generated from each sub category

SELECT
    p.SubcategoryKey,
    SUM((pr.upusd - pr.ucusd) * s.Quantity) AS ProfitUSD,
    SUM(pr.upusd * s.Quantity) AS RevenueUSD
FROM
    sales s
JOIN
    products pr ON s.ProductKey = pr.ProductKey
JOIN
    products p ON pr.CategoryKey = p.CategoryKey
GROUP BY
    p.SubcategoryKey;
    
11) To find the total sales and revenue in every month from 2016 to 2021

SELECT 
    DATE_FORMAT(s.Orderdate, '%Y-%m') AS Month,
    SUM(s.Quantity) AS totalsales,
    SUM(s.Quantity * p.upusd) AS TotalRevenue
FROM 
    projectspark.sales AS s
JOIN 
    projectspark.products AS p ON s.ProductKey = p.ProductKey
GROUP BY 
    Month
ORDER BY 
    Month;
    
    12) To find the customers purchasing frequency based on the no of orders

SELECT 
    c.CustomerKey,
    c.Name,
    COUNT(s.OrderNumber) AS PurchaseFrequency
FROM 
    projectspark.sales AS s
JOIN 
    projectspark.customers AS c ON s.CustomerKey = c.CustomerKey
GROUP BY 
    c.CustomerKey, c.Name
ORDER BY 
    PurchaseFrequency DESC;
    

13) Customer segmentation based on number of orders ( categories: VIP , Loyal , Occassional )

WITH CustomerOrders AS (
    SELECT 
        s.CustomerKey,  
        COUNT(s.OrderNumber) AS OrderCount
    FROM 
        projectspark.sales s  
    GROUP BY 
        s.CustomerKey
)
SELECT 
    c.CustomerKey,  -- Corrected column name
    COALESCE(co.OrderCount, 0) AS OrderCount,
    CASE
        WHEN COALESCE(co.OrderCount, 0) > 10 THEN 'VIP Customer'
        WHEN COALESCE(co.OrderCount, 0) BETWEEN 5 AND 10 THEN 'Loyal Customer'
        WHEN COALESCE(co.OrderCount, 0) BETWEEN 1 AND 4 THEN 'Occasional Customer'
        ELSE 'No Orders'
    END AS CustomerOrderingType
FROM 
    projectspark.customers c  -- Specify the correct schema name
LEFT JOIN
    CustomerOrders co ON c.CustomerKey = co.CustomerKey;  -- Corrected column name
    
 14)
 SELECT gender, COUNT(*) AS Count_gender
FROM customers
GROUP BY gender;

-- Age bucketing
SELECT
    age_bucket,
    COUNT(*) AS count
FROM (
    SELECT
        *,
        CASE
            WHEN YEAR(STR_TO_DATE(Order_date, '%Y-%m-%d')) - YEAR(STR_TO_DATE(birthday, '%Y-%m-%d')) <= 18 THEN '<=18'
            WHEN YEAR(STR_TO_DATE(Order_date, '%Y-%m-%d')) - YEAR(STR_TO_DATE(birthday, '%Y-%m-%d')) BETWEEN 18 AND 25 THEN '18-25'
            WHEN YEAR(STR_TO_DATE(Order_date, '%Y-%m-%d')) - YEAR(STR_TO_DATE(birthday, '%Y-%m-%d')) BETWEEN 25 AND 35 THEN '25-35'
            WHEN YEAR(STR_TO_DATE(Order_date, '%Y-%m-%d')) - YEAR(STR_TO_DATE(birthday, '%Y-%m-%d')) BETWEEN 35 AND 45 THEN '35-45'
            WHEN YEAR(STR_TO_DATE(Order_date, '%Y-%m-%d')) - YEAR(STR_TO_DATE(birthday, '%Y-%m-%d')) BETWEEN 45 AND 55 THEN '45-55'
            WHEN YEAR(STR_TO_DATE(Order_date, '%Y-%m-%d')) - YEAR(STR_TO_DATE(birthday, '%Y-%m-%d')) BETWEEN 55 AND 65 THEN '55-65'
            ELSE '>65'
        END AS age_bucket
    FROM final
) AS age_groups
GROUP BY age_bucket;

SELECT 
    continent,country,state,city, 
    COUNT(CustomerKey) AS customer_count
FROM 
    CUSTOMERS
GROUP BY 
    continent,country,state,city
ORDER BY 
    customer_count DESC
    
    -- Catagory and sub catagory analysis
SELECT
    category,subcategory,
    ROUND(SUM(unit_price_usd * quantity),2) AS total_sales
FROM overall
GROUP BY category,subcategory
ORDER BY total_sales DESC;