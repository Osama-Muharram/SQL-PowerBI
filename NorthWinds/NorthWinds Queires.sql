USE NorthWinds;

-- CREATE SCHEMA Calculation;

-- Explore Data Analysis

-- Categories Table
SELECT * FROM Categories;

-- CustomerCustomerDemo Has No Data
SELECT * FROM CustomerCustomerDemo;

-- CustomerDemographics Has No Data
SELECT * FROM CustomerDemographics;

-- Customers Table
SELECT * FROM Customers;

-- Employees Table
SELECT * FROM Employees;

-- EmployeeTerritores Table
SELECT * FROM EmployeeTerritories;

-- OrderDetails Table
SELECT * FROM OrderDetails;

-- Orders Table
SELECT * FROM Orders;

-- Products Table
SELECT * FROM products;

-- Region Table 
SELECT * FROM Region;

-- Shipper Table
SELECT * FROM Shippers;

-- Suppliers Table
SELECT * FROM Suppliers;

-- Territories Table
SELECT * FROM Territories;

/*
Calculations And Queries
*/

-- Create A View To Get LineFrieght
-- CREATE VIEW KPIs AS 
SELECT
	OrderDetails.OrderID,
	Quantity,
	UnitPrice * Quantity AS QntPrice,
	UnitPrice * Quantity * Discount AS DiscountAmt,
	Freight / OrderCount AS LineFreight,
	YEAR(OrderDate) AS FinancialYear
FROM
	(
	SELECT 
		OrderID,
		COUNT(OrderID) AS OrderCount
	FROM OrderDetails
	GROUP BY OrderID
	) AS Counts
JOIN OrderDetails ON OrderDetails.OrderID = Counts.OrderID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID;

-- Financial And Quantitative KPIs For Each Year
WITH Amts AS (
	SELECT 
		SUM(Quantity) AS TotalQnts,
		COUNT(OrderID) AS TotalItems,
		COUNT(DISTINCT OrderID) AS TotalOrders,
		SUM(LineFreight) AS TotalFreight,
		SUM(QntPrice - DiscountAmt) AS Subtotal,
		SUM(QntPrice + LineFreight - DiscountAmt) AS TotalDue,
		FinancialYear
	FROM KPIs
	GROUP BY FinancialYear
),
StartValue AS (
	SELECT  
		SUM(QntPrice + LineFreight - DiscountAmt) AS FirstValue
	FROM KPIs
	WHERE FinancialYear = 
		(
		SELECT MIN(FinancialYear) FROM KPIs
		)
),
EndValue AS (
	SELECT  
		SUM(QntPrice + LineFreight - DiscountAmt) AS LastValue
	FROM KPIs
	WHERE FinancialYear = 
		(
		SELECT MAX(FinancialYear) FROM KPIs
		)
),
YearCounts AS (
	SELECT 
		COUNT(DISTINCT FinancialYear) AS N
	FROM KPIs
)
SELECT 
	FORMAT(TotalQnts, '#,##0.##') AS TotalQnts,
	FORMAT(TotalItems, '#,##0.##') AS TotalItems,
	FORMAT(TotalOrders, '#,##0.##') AS TotalOrders,
	FORMAT(TotalFreight, '#,##0.##') AS TotalFreight,
	FORMAT(Subtotal, '#,##0.##') AS Subtotal,
	FORMAT(TotalDue, '#,##0.##') AS TotalDue,
	FORMAT(
		(TotalDue- LAG(TotalDue) OVER(ORDER BY FinancialYear)) / 
		LAG(TotalDue) OVER(ORDER BY FinancialYear) * 100,
		'#,##0.00') AS "GrowthRate%",
	FORMAT((POWER (LastValue / FirstValue, 1.0 / N) - 1 ) * 100,
	'#,##0.##') AS "CAGR%"

FROM Amts, StartValue, EndValue, YearCounts
ORDER BY FinancialYear;

-- Financial And Quantitative KPIs For All Years
WITH Amts AS (
	SELECT 
		SUM(Quantity) AS TotalQnts,
		COUNT(OrderID) AS TotalItems,
		COUNT(DISTINCT OrderID) AS TotalOrders,
		SUM(LineFreight) AS TotalFreight,
		SUM(QntPrice - DiscountAmt) AS Subtotal,
		SUM(QntPrice + LineFreight - DiscountAmt) AS TotalDue
	FROM KPIs
),
StartValue AS (
	SELECT  
		SUM(QntPrice + LineFreight - DiscountAmt) AS FirstValue
	FROM KPIs
	WHERE FinancialYear = 
		(
		SELECT MIN(FinancialYear) FROM KPIs
		)
),
EndValue AS (
	SELECT  
		SUM(QntPrice + LineFreight - DiscountAmt) AS LastValue
	FROM KPIs
	WHERE FinancialYear = 
		(
		SELECT MAX(FinancialYear) FROM KPIs
		)
),
YearCounts AS (
	SELECT 
		COUNT(DISTINCT FinancialYear) AS N
	FROM KPIs
)
SELECT 
	FORMAT(TotalQnts, '#,##0.##') AS TotalQnts,
	FORMAT(TotalItems, '#,##0.##') AS TotalItems,
	FORMAT(TotalOrders, '#,##0.##') AS TotalOrders,
	FORMAT(TotalFreight, '#,##0.##') AS TotalFreight,
	FORMAT(Subtotal, '#,##0.##') AS Subtotal,
	FORMAT(Amts.TotalDue, '#,##0.##') AS TotalDue,

	FORMAT((POWER (LastValue / FirstValue, 1.0 / N) - 1 ) * 100, '#,##0.##') AS "CAGR%"

FROM Amts, StartValue, EndValue, YearCounts

-- Top Products By Quantity
SELECT 
	CategoryName,
	ProductName,
	FORMAT(SUM(Quantity), '#,##0.##') AS TotalQnt,
	RANK() OVER(ORDER BY SUM(Quantity) DESC) AS TopProduct
FROM OrderDetails AS OD
JOIN Products AS P ON OD.ProductID = P.ProductID
JOIN Categories AS G ON G.CategoryID = P.CategoryID
GROUP BY CategoryName, ProductName
ORDER BY TopProduct 

-- Top Categories By Quantity
SELECT 
	CategoryName,
	FORMAT(SUM(Quantity), '#,##0.##') AS TotalQnt,
	RANK() OVER(ORDER BY SUM(Quantity) DESC) AS TopCategory
FROM OrderDetails AS OD
JOIN Products AS P ON OD.ProductID = P.ProductID
JOIN Categories AS G ON G.CategoryID = P.CategoryID
GROUP BY CategoryName
ORDER BY TopCategory 

-- Top Products By Quantity Per Category
SELECT 
	CategoryName,
	ProductName,
	FORMAT(SUM(Quantity), '#,##0.##') AS TotalQnt,
	RANK() OVER(PARTITION BY CategoryName ORDER BY SUM(Quantity) DESC) 
	AS TopProductsPerCategory	
FROM OrderDetails AS OD
JOIN Products AS P ON OD.ProductID = P.ProductID
JOIN Categories AS G ON G.CategoryID = P.CategoryID
GROUP BY CategoryName,ProductName
ORDER BY CategoryName, TopProductsPerCategory 

-- Top Customer City
SELECT
	DISTINCT ShipCountry AS CustomerCountry,
	ShipCity AS CustomerCity,
	FORMAT(SUM(QntPrice + LineFreight - DiscountAmt),
	'#,##0.##') AS TotalDue,
	RANK() OVER(ORDER BY SUM(QntPrice + LineFreight - DiscountAmt) DESC) 
	AS TopCustomerCity
FROM Orders AS O
JOIN KPIs ON O.OrderID = KPIs.OrderID
GROUP BY ShipCountry, ShipCity
ORDER BY TopCustomerCity

-- Top Customer Country
SELECT 
	DISTINCT ShipCountry AS CustomerCountry,
	FORMAT(SUM(QntPrice + LineFreight - DiscountAmt),
	'#,##0.##') AS TotalDue,
	RANK() OVER(ORDER BY SUM(QntPrice + LineFreight - DiscountAmt) DESC) 
	AS TopCustomerCountry
FROM Orders AS O
JOIN KPIs ON O.OrderID = KPIs.OrderID
GROUP BY ShipCountry
ORDER BY TopCustomerCountry

-- Top Customer City Per Country
SELECT 
	DISTINCT ShipCountry AS CustomerCountry,
	ShipCity AS CustomerCity,
	FORMAT(SUM(QntPrice + LineFreight - DiscountAmt),
	'#,##0.##') AS TotalDue,
	DENSE_RANK() OVER(PARTITION BY ShipCountry
	ORDER BY SUM(QntPrice + LineFreight - DiscountAmt) DESC) 
	AS TopCustomerCityPerCountry
FROM Orders AS O
JOIN KPIs ON O.OrderID = KPIs.OrderID
GROUP BY ShipCountry, ShipCity
ORDER BY CustomerCountry

-- Customer Details
SELECT
	CompanyName,
	ContactTitle,
	City,
	Country,
	FORMAT(COUNT(DISTINCT Orders.OrderID), '#,##0.##') AS TotalOrders,
	FORMAT(SUM(Quantity), '#,##0.##') AS TotalQnt,
	FORMAT(SUM(LineFreight), '#,##0.##') AS TotalFreight,
	FORMAT(SUM(QntPrice - DiscountAmt), '#,##0.##') AS Subtotal,
	FORMAT(SUM(QntPrice + LineFreight - DiscountAmt),
	'#,##0.##') AS TotalDue
FROM Customers
JOIN Orders ON Orders.CustomerID = Customers.CustomerID
JOIN KPIs ON Orders.OrderID = KPIs.OrderID
GROUP BY CompanyName, ContactTitle, City, Country
ORDER BY CompanyName

-- Order Items
SELECT
	KPIs.OrderID,
	CompanyName,
	CAST(OrderDate AS DATE) AS OrderDate,
	CAST(RequiredDate AS DATE) AS RequiredDate,
	CAST(ShippedDate AS DATE) AS ShippedDate,
	City,
	Country,
	FORMAT(COUNT(KPIs.OrderID), '#,##0.##') AS TotalItems,
	FORMAT(SUM(Quantity), '#,##0.##') AS TotalQnt,
	FORMAT(SUM(LineFreight), '#,##0.##') AS TotalFreight,
	FORMAT(SUM(QntPrice - DiscountAmt), '#,##0.##') AS Subtotal,
	FORMAT(SUM(QntPrice + LineFreight - DiscountAmt),
	'#,##0.##') AS TotalDue
FROM Customers
JOIN Orders ON Orders.CustomerID = Customers.CustomerID
JOIN KPIs ON Orders.OrderID = KPIs.OrderID
GROUP BY KPIs.OrderID, CompanyName, OrderDate, RequiredDate, 
	ShippedDate, ContactTitle, City, Country
ORDER BY CompanyName