USE "Contoso 100K";

-- Explore Data Analysis

-- Data.CurrencyExchange Table
SELECT * FROM Data.CurrencyExchange;

SELECT DISTINCT ToCurrency FROM Data.CurrencyExchange;

-- Data.Customer Table
SELECT * FROM Data.Customer;

SELECT DISTINCT CountryFull FROM Data.Customer ORDER BY CountryFull ASC;

SELECT DISTINCT Continent, CountryFull, StateFull, City
FROM Data.Customer ORDER BY CountryFull ASC;

-- Data.Date Table
SELECT * FROM Data.Date;

SELECT DISTINCT "Year Quarter Number"  FROM Data.Date
ORDER BY "Year Quarter Number";

SELECT DISTINCT "Year Month Number", "Year Month" FROM Data.Date
ORDER BY "Year Month Number";

-- Data.GeoLocations Table
SELECT * FROM Data.GeoLocations;

SELECT SUM(NumCustomers) FROM Data.GeoLocations;

-- Data.OrderRows Table
SELECT * FROM Data.OrderRows;

SELECT DISTINCT OrderKey, ProductKey FROM Data.OrderRows;

SELECT "Line Number", COUNT("Line Number") AS Counts 
FROM Data.OrderRows
GROUP BY "Line Number";

-- Data.Orders Table
SELECT * FROM Data.Orders;

-- Data.Product Table
SELECT * FROM Data.Product;

-- Data.Store Table
SELECT * FROM Data.Store;

/*
Calculations And Queries
*/



