USE "Contoso 100K";

-- Explore Data Analysis

-- Data.CurrencyExchange Table
SELECT * FROM Data.CurrencyExchange;

SELECT DISTINCT ToCurrency FROM Data.CurrencyExchange;

-- Data.Customer Table
SELECT * FROM Data.Customer;

SELECT * FROM Data.Customer
WHERE Company IS NULL;

SELECT DISTINCT CountryFull FROM Data.Customer ORDER BY CountryFull ASC;

SELECT DISTINCT Continent, CountryFull, StateFull, City
FROM Data.Customer ORDER BY CountryFull ASC;

SELECT COUNT(CustomerKey) CustomerCounts FROM Data.Customer;

-- Data.Date Table
SELECT * FROM Data.Date;

SELECT MIN(Date) AS FirstOrder, MAX(Date) AS LastOrder FROM Data.Date;

SELECT DISTINCT "Year Quarter Number"  FROM Data.Date
ORDER BY "Year Quarter Number";

SELECT DISTINCT "Year Month Number", "Year Month" FROM Data.Date
ORDER BY "Year Month Number";

-- Data.GeoLocations Table
SELECT * FROM Data.GeoLocations;

SELECT SUM(NumCustomers) FROM Data.GeoLocations;

-- Data.OrderRows Table
SELECT * FROM Data.OrderRows;

SELECT * FROM Data.OrderRows WHERE OrderKey = 1459009;

SELECT * FROM Data.OrderRows WHERE [Line Number] = 6;

SELECT DISTINCT OrderKey, ProductKey FROM Data.OrderRows;

SELECT "Line Number", COUNT("Line Number") AS Counts 
FROM Data.OrderRows
GROUP BY "Line Number";

-- Data.Orders Table
SELECT * FROM Data.Orders;

SELECT StoreKey, COUNT(StoreKey) 
FROM Data.Orders
WHERE CustomerKey = 1214274 
GROUP BY StoreKey;

SELECT 
	COUNT(DISTINCT CustomerKey) CustomerNo
FROM Data.Orders
WHERE YEAR([Order Date]) BETWEEN 2011 AND 2019 
GROUP BY StoreKey;

-- Data.Product Table
SELECT * FROM Data.Product;

SELECT * FROM Data.Product 
WHERE [Unit Price] = (SELECT MAX([Unit Price]) FROM Data.Product);

SELECT DISTINCT Manufacturer FROM Data.Product;

SELECT DISTINCT Category FROM Data.Product;

SELECT DISTINCT Subcategory FROM Data.Product;


-- Data.Store Table
SELECT * FROM Data.Store;

SELECT * FROM Data.Store
WHERE [Close Date] = '2019-11-03'

-- Create A View 
-- CREATE VIEW KPIs AS 
SELECT 
OD.OrderKey,
	Quantity,
	[Unit Price],
	[Unit Cost],
	[Net Price],
	YEAR([Order Date]) AS FinancialYear
FROM Data.OrderRows AS OD
JOIN Data.Orders AS O ON OD.OrderKey = O.OrderKey
WHERE YEAR([Order Date]) BETWEEN 2011 AND 2019;

/*
Calculations And Queries
*/

-- Getting Line Total 
SELECT 
	*,
	Quantity * [Net Price] AS LineTotal 
FROM Data.OrderRows
ORDER BY OrderKey, [Line Number];

-- Financial And Quantitative KPIs For All Years
WITH OverTime AS (
	SELECT 
		COUNT(DISTINCT OrderKey) AS TotalOrders ,
		COUNT(OrderKey) AS TotalItems,
		SUM(Quantity) AS TotalQnt,
		SUM([Unit Cost]) AS TotalCost,
		SUM(Quantity * [Net Price]) AS TotalDue,
		SUM(Quantity * [Net Price] - [Unit Cost]) AS MarginProfit
	FROM KPIs
),
StartYear AS (
	SELECT 
		SUM(Quantity * [Net Price]) AS FirstYear
	FROM KPIs
	WHERE FinancialYear = 2011
),
EndYear AS (
	SELECT 
		SUM(Quantity * [Net Price]) AS LastYear
	FROM KPIs
	WHERE FinancialYear = 2019
),
YearsCount AS (
	SELECT 
		COUNT(DISTINCT FinancialYear) AS N
	FROM KPIs
)
SELECT
	FORMAT(TotalOrders, '#,##0.##') AS TotalOrders,
	FORMAT(TotalItems, '#,##0.##') AS TotalItems,
	FORMAT(TotalQnt, '#,##0.##') AS TotalItems,
	FORMAT(TotalCost, '#,##0.00') AS TotalCost,
	FORMAT(TotalDue, '#,##0.00') AS TotalDue,
	FORMAT(MarginProfit, '#,##0.00') AS MarginProfit,
	FORMAT((POWER (LastYear / FirstYear, 1.0 / N) - 1) * 100, '#,##0.00') AS "CAGR%"
FROM OverTime, StartYear, EndYear, YearsCount;

-- Financial And Quantitative KPIs Over Years
WITH OverTime AS (
	SELECT 
		COUNT(DISTINCT OrderKey) AS TotalOrders ,
		COUNT(OrderKey) AS TotalItems,
		SUM(Quantity) AS TotalQnt,
		SUM([Unit Cost]) AS TotalCost,
		SUM(Quantity * [Net Price]) AS TotalDue,
		SUM(Quantity * [Net Price] - [Unit Cost]) AS MarginProfit,
		FinancialYear
	FROM KPIs
	GROUP BY FinancialYear
)
SELECT
	FinancialYear,
	FORMAT(TotalOrders, '#,##0.##') AS TotalOrders,
	FORMAT(TotalItems, '#,##0.##') AS TotalItems,
	FORMAT(TotalQnt, '#,##0.##') AS TotalItems,
	FORMAT(TotalCost, '#,##0.00') AS TotalCost,
	FORMAT(TotalDue, '#,##0.00') AS TotalDue,
	FORMAT(MarginProfit, '#,##0.00') AS MarginProfit,
	FORMAT(
		(TotalDue - LAG(TotalDue) OVER(ORDER BY FinancialYear)) / 
		LAG(TotalDue) OVER(ORDER BY FinancialYear) * 100,
		'#,##0.0') AS "GrowthRate%"
FROM OverTime
ORDER BY FinancialYear;
-------------------



