-- Get All Vehicles Between 1950 And 2000.
SELECT 
	* 
FROM 
	VehicleDetails 
WHERE
	Year BETWEEN 1950 AND 2000;

-----------------------------------------------------------------------

-- Get Number Of Vehicles Made Between 1950 And 2000.
SELECT 
	COUNT (*) AS NumboerOfVehicles
FROM 
	VehicleDetails 
WHERE
	Year BETWEEN 1950 AND 2000;

-----------------------------------------------------------------------

-- Get Number Of Vehicles Made Between 1950 And 2000 Per Make And
-- Order Them By Number Of Vehicles Descending.
SELECT 
	Makes.Make, 
	COUNT(*) AS NumberOfVehicles
FROM 
	VehicleDetails JOIN Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE
	Year BETWEEN 1950 AND 2000
GROUP BY
	Makes.Make
ORDER BY 
	NumberOfVehicles DESC;

-----------------------------------------------------------------------

--  Get All Makes That Have Manufactured More Than 12000 Vehicles In
-- Years 1950 To 2000
SELECT 
	Makes.Make, 
	COUNT(*) AS NumberOfVehicles
FROM 
	VehicleDetails JOIN Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE
	Year BETWEEN 1950 AND 2000
GROUP BY
	Makes.Make
HAVING 
	COUNT(*) >= 12000
ORDER BY 
	NumberOfVehicles DESC;

-- ADVANCED SOLUTION
SELECT * 
FROM 
	(
	SELECT 
		Makes.Make, 
		COUNT(*) AS NumberOfVehicles
	FROM 
		VehicleDetails JOIN Makes ON VehicleDetails.MakeID = Makes.MakeID
	WHERE
		Year BETWEEN 1950 AND 2000
	GROUP BY
		Makes.Make
	) AS SUB
WHERE 
	NumberOfVehicles > 12000;

-----------------------------------------------------------------------

-- Get Number Of Vehicles Made Between 1950 And 2000 Per Make And
-- Add Total Vehicles Column Beside
SELECT 
	Makes.Make,
	COUNT(*) AS NumberOfVehicles,
	FORMAT((SELECT COUNT(*) FROM VehicleDetails), 'N0') AS TotalVehicles
FROM 
	VehicleDetails JOIN Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE
	Year BETWEEN 1950 AND 2000
GROUP BY
	Makes.Make
ORDER BY 
	NumberOfVehicles DESC;

-----------------------------------------------------------------------

-- Get Number Of Vehicles Made Between 1950 And 2000 Per Make And 
-- Add Total Vehicles Column Beside It, Then Calculate It's Percentage
SELECT 
	Makes.Make,
	COUNT(*) AS NumberOfVehicles,
	FORMAT((SELECT COUNT(*) FROM VehicleDetails), 'N0') AS TotalVehicles,
	FORMAT((COUNT(*) * 1.0/ (SELECT COUNT(*) FROM VehicleDetails)), 'P') AS PercentageOfTotal
FROM 
	VehicleDetails JOIN Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE
	Year BETWEEN 1950 AND 2000
GROUP BY
	Makes.Make
ORDER BY 
	NumberOfVehicles DESC;

-- ANOTHER SOLUTION
SELECT 
	* ,
	CAST(NumberOfVehicles AS FLOAT) / CAST(TotalVehicles AS FLOAT) AS PercentageOfTotal
FROM
	(
	SELECT 
	Makes.Make,
	COUNT(*) AS NumberOfVehicles,
	(SELECT COUNT(*) FROM VehicleDetails) AS TotalVehicles
FROM 
	VehicleDetails JOIN Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE
	Year BETWEEN 1950 AND 2000
GROUP BY
	Makes.Make
) AS RESULT
ORDER BY 
	NumberOfVehicles DESC;

-----------------------------------------------------------------------

-- Get Make, FuelTypeName And Number Of Vehicles Per FuelType Per Make
SELECT 
	Makes.Make,
	FuelTypes.FuelTypeName,
	COUNT(*) AS NumberOfVehicles
FROM 
	VehicleDetails 
JOIN 
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN 
	FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
WHERE
	YEAR BETWEEN 1950 AND 2000
GROUP BY 
	Makes.Make,
	FuelTypes.FuelTypeName
ORDER BY 
	Makes.Make;

-----------------------------------------------------------------------

-- Get All Vehicles That Runs With GAS
SELECT 
	VehicleDetails.*,
	FuelTypes.FuelTypeName AS FuelTypeName
FROM 
	VehicleDetails 
JOIN 
	FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
WHERE 
	FuelTypeName = 'GAS';

-----------------------------------------------------------------------

-- Get All Makes That Runs With GAS
SELECT 
	DISTINCT Makes.Make,
	FuelTypes.FuelTypeName
FROM
	VehicleDetails
JOIN 
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN 
	FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
WHERE
	FuelTypeName = 'GAS';

-----------------------------------------------------------------------

-- Get Total Makes That Runs With GAS
SELECT 
	COUNT(DISTINCT Makes.Make) AS TotalMakeRunsOnGAS
FROM
	VehicleDetails
JOIN 
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN 
	FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
WHERE
	FuelTypeName = 'GAS';

-----------------------------------------------------------------------

-- Count Vehicles By Make And Order Them By NumberOfVehicles From High To Low.
SELECT 
	Makes.Make, 
	COUNT(*) AS NumberOfVehicles
FROM 
	VehicleDetails
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY
	Makes.Make
ORDER BY
	NumberOfVehicles DESC;

-----------------------------------------------------------------------

-- Get All Makes/Count Of Vehicles That Manufactures More Than 20K Vehicles
SELECT 
	Makes.Make, 
	COUNT(*) AS NumberOfVehicles
FROM 
	VehicleDetails
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY
	Makes.Make
HAVING 
	COUNT(*) > 20000
ORDER BY
	NumberOfVehicles DESC;	

-----------------------------------------------------------------------

-- Get All Makes With Make Starts With 'B'
SELECT 
	Make
FROM 
	Makes
WHERE 
	Make LIKE 'B%';

-----------------------------------------------------------------------

-- Get All Makes With Make Ends With 'W'
SELECT	
	Make
FROM 
	Makes
WHERE
	Make LIKE '%W';

-----------------------------------------------------------------------

-- Get All Makes That Manufactures DriveTypeName = FWD
SELECT 
	DISTINCT Makes.Make,
	DriveTypes.DriveTypeName
FROM 
	VehicleDetails
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN
	DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
WHERE	
	DriveTypeName = 'FWD';

-----------------------------------------------------------------------

-- Get Total Makes That Mantufactures DriveTypeName=FWD
SELECT 
	COUNT(DISTINCT Makes.Make) AS TotalMakeWithFWD
FROM 
	VehicleDetails
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN
	DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
WHERE	
	DriveTypeName = 'FWD';

-----------------------------------------------------------------------

-- Get Total Vehicles Per DriveTypeName Per Make and Order Them Per Make ASC 
-- Then Per Total DESC
SELECT 
	DISTINCT Makes.Make,
	DriveTypes.DriveTypeName,
	COUNT(*) AS Total
FROM 
	VehicleDetails
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN
	DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
GROUP BY 
	Makes.Make,
	DriveTypes.DriveTypeName
ORDER BY
	Makes.Make ASC ,
	Total DESC;

-----------------------------------------------------------------------

-- Get Total Vehicles Per DriveTypeName Per Make Then Filter Only Results 
-- With Total > 10,000
SELECT 
	DISTINCT Makes.Make,
	DriveTypes.DriveTypeName,
	COUNT(*) AS Total
FROM 
	VehicleDetails
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN
	DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
GROUP BY 
	Makes.Make,
	DriveTypes.DriveTypeName
HAVING 
	COUNT(*) > 10000
ORDER BY
	Makes.Make ASC ,
	Total DESC;

-----------------------------------------------------------------------

-- Get All Vehicles That Number Of Doors Is Not Specified
SELECT 
	*
FROM
	VehicleDetails
WHERE 
	NumDoors IS NULL;

-----------------------------------------------------------------------

--Get Total Vehicles That Number Of Doors Is Not Specified
SELECT 
	* 
FROM
	VehicleDetails
WHERE
	NumDoors IS NOT NULL;

-----------------------------------------------------------------------

-- Get Percentage Of Vehicles That Has No Doors Specified
SELECT 
	(
	CAST((SELECT COUNT(*) FROM VehicleDetails WHERE NumDoors IS NULL) AS FLOAT)
	/
	CAST((SELECT COUNT(*) FROM VehicleDetails) AS FLOAT)
	) AS PercentageOfNumSpecifiedDoors;

-----------------------------------------------------------------------

-- Get MakeID , Make, SubModelName For All Vehicles That Have SubModelName 'Elite'
SELECT 
	DISTINCT Makes.MakeID,
	Makes.Make,
	SubModels.SubModelName
FROM 
	VehicleDetails
JOIN 
	Makes ON VehicleDetails.MakeID = Makes.MakeID
JOIN	
	SubModels ON VehicleDetails.SubModelID = SubModels.SubModelID
WHERE 
	SubModels.SubModelName = 'Elite';

-----------------------------------------------------------------------

-- Get All Vehicles That Have Engines > 3 Liters And Have Only 2 Doors
SELECT 
	* 
FROM
	VehicleDetails
WHERE 
	Engine_Liter_Display > 3  AND NumDoors = 2;
-----------------------------------------------------------------------

-- Get Make And Vehicles That The Engine Contains 'OHV' And Have Cylinders = 4
SELECT 
	VehicleDetails.*,
	Makes.Make
FROM 
	VehicleDetails
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE
	VehicleDetails.Engine LIKE '%OHV%' AND VehicleDetails.Engine_Cylinders = 4;

-----------------------------------------------------------------------

-- Get All Vehicles That Their Body Is 'Sport Utility' And Year > 2020
SELECT 
	VehicleDetails.*,
	Bodies.BodyName
FROM
	VehicleDetails
JOIN
	Bodies ON VehicleDetails.BodyID = Bodies.BodyID
WHERE 
	Bodies.BodyName = 'Sport Utility' AND VehicleDetails.Year > 2020;

-----------------------------------------------------------------------

-- Get All Vehicles That Their Body Is 'Coupe' Or 'Hatchback' Or 'Sedan'
SELECT
	VehicleDetails.*,
	Bodies.BodyName
FROM
	VehicleDetails
JOIN
	Bodies ON VehicleDetails.BodyID = Bodies.BodyID
WHERE
	Bodies.BodyName IN ('Coupe' , 'Hatchback', 'Sedan');

-----------------------------------------------------------------------

-- Get All Vehicles That Their Bbody Is 'Coupe' Or 'Hatchback' Or 'Sedan'
-- And Manufactured In Year 2008 Or 2020 Or 2021
SELECT
	VehicleDetails.*,
	Bodies.BodyName
FROM
	VehicleDetails
JOIN
	Bodies ON VehicleDetails.BodyID = Bodies.BodyID
WHERE
	Bodies.BodyName IN ('Coupe' , 'Hatchback', 'Sedan')
	AND
	VehicleDetails.Year IN ('2008', '2020', '2021');

-----------------------------------------------------------------------

-- Return Found=1 If There Is Any Vehicle Made In Year 1950
SELECT
	1 AS Found
WHERE EXISTS
	(SELECT TOP 1 * FROM VehicleDetails WHERE Year = 1950);

-- ADVANCED SOLUTION
SELECT 
    CASE 
        WHEN EXISTS (SELECT TOP 1 * FROM VehicleDetails WHERE Year = 1950) THEN 1
        ELSE 0
    END AS Found;

-----------------------------------------------------------------------

-- Get All Vehicle_Display_Name, NumDoors and Add Extra Column To Describe 
-- Number Of Doors By Words, And If Door Is Null Display 'Not Set'

SELECT DISTINCT NumDoors FROM VehicleDetails ORDER BY NumDoors;

SELECT 
	Vehicle_Display_Name, 
	NumDoors,
	CASE
		WHEN NumDoors = 0 THEN 'NO DOORS'
		WHEN NumDoors = 1 THEN 'ONE DOOR'
		WHEN NumDoors = 2 THEN 'TWO DOORS'
		WHEN NumDoors = 3 THEN 'THREE DOORS'
		WHEN NumDoors = 4 THEN 'FOUR DOORS'
		WHEN NumDoors = 5 THEN 'FIVE DOORS'
		WHEN NumDoors = 6 THEN 'SIX DOORS'
		WHEN NumDoors = 7 THEN 'SEVEN DOORS'
		WHEN NumDoors = 8 THEN 'EIGHT DOORS'
		WHEN NumDoors IS NULL THEN 'NOT SET'
		ELSE 'UNNKOWN'
	END AS DoorDescribtion
FROM 
	VehicleDetails;   

-----------------------------------------------------------------------
-- Get All Vehicle_Display_Name, Year And Add Extra Column To Calculate
-- The Age Of The Car Then Sort The Results By Age DESC.
SELECT	
	Vehicle_Display_Name,
	Year,
	YEAR(GETDATE()) - Year AS Age
FROM
	VehicleDetails
ORDER BY
	Age DESC;

-----------------------------------------------------------------------

-- Get All Vehicle_Display_Name, Year, Age For Vehicles That Their Age 
-- Between 15 And 25 Years Old
SELECT 
	*
FROM 
	(
	SELECT	
		Vehicle_Display_Name,
		Year,
		YEAR(GETDATE()) - Year AS Age
	FROM	
		VehicleDetails
	) AS VehicleAge
WHERE
	Age BETWEEN 15 AND 25
ORDER BY 
		Age DESC;
-----------------------------------------------------------------------

-- Get Minimum Engine CC , Maximum Engine CC , And Average Engine CC Of All Vehicles
SELECT 
	MIN(Engine_CC) AS MinimumEngineCC,
	MAX(Engine_CC) AS MaximumEngineCC,
	AVG(Engine_CC) AS AverageEngineCC
FROM
	VehicleDetails;

-----------------------------------------------------------------------

-- Get All Vehicles That Have The Minimum Engine_CC
SELECT 
	* 
FROM
	VehicleDetails
WHERE
	Engine_CC = 
	(
	SELECT 
		MIN(Engine_CC) AS MinimumEngineCC
	FROM
		VehicleDetails
	);

-----------------------------------------------------------------------

-- Get All Vehicles That Have The Maximum Engine_CC
SELECT 
	* 
FROM
	VehicleDetails
WHERE
	Engine_CC = 
	(
	SELECT 
		MAX(Engine_CC) AS MinimumEngineCC
	FROM
		VehicleDetails
	);

-----------------------------------------------------------------------

-- Get All Vehicles That Have Engin_CC Below Average
SELECT 
	* 
FROM
	VehicleDetails
WHERE
	Engine_CC < 
	(
	SELECT 
		AVG(Engine_CC) AS MinimumEngineCC
	FROM
		VehicleDetails
	);

-----------------------------------------------------------------------

-- Get Total  Vehicles That Have Engin_CC Above Average
SELECT 
	COUNT(*) AS NumberOfVehiclesAboveAverageEngineCC
FROM
	VehicleDetails
WHERE
	Engine_CC > 
	(
	SELECT 
		AVG(Engine_CC) AS MinimumEngineCC
	FROM
		VehicleDetails
	);

-----------------------------------------------------------------------

-- Get All Unique EnginE_CC And Sort Them Desc
SELECT 
	DISTINCT EnginE_CC
FROM 
	VehicleDetails
ORDER BY 
	Engine_CC DESC;

-----------------------------------------------------------------------

-- Get The Maximum 3 Engine CC
SELECT 
	DISTINCT TOP 3 EnginE_CC
FROM 
	VehicleDetails
ORDER BY 
		Engine_CC DESC;
	
-----------------------------------------------------------------------

-- Get All Vehicles That Has One Of The Max 3 Engine CC
SELECT 
	Vehicle_Display_Name
FROM 
	VehicleDetails
WHERE
	Engine_CC IN 
	(
	SELECT 
		DISTINCT TOP 3 EnginE_CC
	FROM 
		VehicleDetails
	ORDER BY 
		Engine_CC DESC
	)
ORDER BY 
		Engine_CC DESC;

-----------------------------------------------------------------------

-- Get All Makes That Manufactures One Of The Max 3 Engine CC
SELECT 
	DISTINCT Makes.Make
FROM 
	VehicleDetails
JOIN 
	Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE
	Engine_CC IN 
	(
	SELECT 
		DISTINCT TOP 3 EnginE_CC
	FROM 
		VehicleDetails
	ORDER BY 
		Engine_CC DESC
	)
ORDER BY 
		Makes.Make ASC;

-----------------------------------------------------------------------

-- Get A Table Of Unique Engine_CC And Calculate Tax Per Engine CC
SELECT 
	DISTINCT Engine_CC, 
	CASE
		WHEN Engine_CC between 0 and 1000 THEN 100
		 WHEN Engine_CC between 1001 and 2000 THEN 200
		 WHEN Engine_CC between 2001 and 4000 THEN 300
		 WHEN Engine_CC between 4001 and 6000 THEN 400
		 WHEN Engine_CC between 6001 and 8000 THEN 500
		 WHEN Engine_CC > 8000 THEN 600	
		ELSE 0
	END as Tax
FROM 
	VehicleDetails
ORDER BY 
	Engine_CC;

-----------------------------------------------------------------------

--Get Make And Total Number Of Doors Manufactured Per Make
SELECT 
	Makes.Make,
	SUM(NumDoors) AS TotalNumbersOfDoors
FROM	
	VehicleDetails
JOIN 
	Makes ON VehicleDetails.MakeID = Makes.MakeID
GROUP BY 
	Makes.Make
ORDER BY
	TotalNumbersOfDoors DESC;

-----------------------------------------------------------------------

-- Get Total Number Of Doors Manufactured By 'Ford'
SELECT 
	*
FROM
	(
	SELECT 
		Makes.Make,
		SUM(NumDoors) AS TotalNumbersOfDoors
	FROM	
		VehicleDetails
	JOIN 
		Makes ON VehicleDetails.MakeID = Makes.MakeID
	GROUP BY 
		Makes.Make
	) AS Ford
WHERE 
	Make = 'Ford';

-- ANOTHER SOLUTION

SELECT        
	Makes.Make,
	Sum(VehicleDetails.NumDoors) AS TotalNumberOfDoors
FROM
	VehicleDetails 
JOIN
	Makes ON VehicleDetails.MakeID = Makes.MakeID

Group By
	Make
Having 
	Make='Ford';

-----------------------------------------------------------------------

-- Get Number Of Models Per Make
SELECT 
	Makes.Make,
	COUNT(*) AS  NumberOfModels
FROM 
	Makes 
JOIN
	MakeModels ON Makes.MakeID = MakeModels.MakeID
GROUP BY 
	Makes.Make
ORDER BY
	NumberOfModels DESC;
	
-----------------------------------------------------------------------

-- Get The Highest 3 Manufacturers That Make The Highest Number Of Models
SELECT 
	TOP 3 Makes.Make,
	COUNT(*) AS  NumberOfModels
FROM 
	Makes 
JOIN
	MakeModels ON Makes.MakeID = MakeModels.MakeID
GROUP BY 
	Makes.Make
ORDER BY
	NumberOfModels DESC;

-----------------------------------------------------------------------

-- Get The Highest Number Of Models Manufactured
SELECT 
	TOP 1 Makes.Make,
	COUNT(*) AS  NumberOfModels
FROM 
	Makes 
JOIN
	MakeModels ON Makes.MakeID = MakeModels.MakeID
GROUP BY 
	Makes.Make
ORDER BY
	NumberOfModels DESC;

-- ANOTHER SOLUTION
SELECT 
	MAX(NumberOfModels) AS TheHighestNumberOfModels
FROM
	(
	SELECT 
		Makes.Make,
		COUNT(*) AS  NumberOfModels
	FROM 
		Makes 
	JOIN
		MakeModels ON Makes.MakeID = MakeModels.MakeID
	GROUP BY 
		Makes.Make
	) AS TheHighestNumberOfModels;
	 
-----------------------------------------------------------------------

-- Get The Highest Manufacturers Manufactured The Highest Number Of Models

SELECT
	Makes.Make,
	COUNT(*) AS NumberOfModels
FROM 
	Makes 
JOIN
	MakeModels ON Makes.MakeID = MakeModels.MakeID
GROUP BY 
	Makes.Make
HAVING
	COUNT(*) = 
		(
		SELECT 
			MAX(NumberOfModels)
		FROM 
			(
			SELECT
				COUNT(*) AS NumberOfModels
			FROM 
				Makes 
			JOIN 
				MakeModels ON Makes.MakeID = MakeModels.MakeID 
			GROUP BY 
				Make
			) AS Highest
		);
		
-----------------------------------------------------------------------

-- Get The Lowest Manufacturers Manufactured The Lowest Number Of Models
SELECT
	Makes.Make,
	COUNT(*) AS NumberOfModels
FROM 
	Makes 
JOIN
	MakeModels ON Makes.MakeID = MakeModels.MakeID
GROUP BY 
	Makes.Make
HAVING
	COUNT(*) = 
		(
		SELECT 
			MIN(NumberOfModels)
		FROM
			(
			SELECT 
				COUNT(*) AS NumberOfModels 
			FROM 
				Makes 
			JOIN 
				MakeModels ON Makes.MakeID = MakeModels.MakeID 
			GROUP BY 
				Makes.Make
			) AS Lowest
		);
	
-----------------------------------------------------------------------

-- Get All Fuel Types , Each Time The Result Should Be Showed In Random Order
SELECT 
	*
FROM 
	FuelTypes
ORDER BY 
	NEWID();
	
-----------------------------------------------------------------------