-- Create a Table Makes
CREATE TABLE Makes (
	MakeID INT IDENTITY (1, 1),
	MakeName VARCHAR (50) NOT NULL,

	CONSTRAINT PK_Makes PRIMARY KEY (MakeID),

	CONSTRAINT UQ_Makes_MakeName UNIQUE (MakeName)
);

INSERT INTO Makes
SELECT DISTINCT Make FROM CarDetails ORDER BY Make;

ALTER TABLE CarDetails
ADD MakeID INT;

UPDATE CarDetails set MakeID = 
(SELECT MakeID FROM Makes WHERE Makes.MakeName = CarDetails.Make);

ALTER TABLE CarDetails
ADD CONSTRAINT FK_CarDetails_Makes FOREIGN KEY 
(MakeID) REFERENCES Makes (MakeID);

ALTER TABLE CarDetails
DROP COLUMN Make;

-------------------------------------------------------------------

-- Create a Table Bodies
CREATE TABLE Bodies (
	BodyID INT IDENTITY (1, 1),
	BodyName VARCHAR (50) NOT NULL,

	CONSTRAINT PK_Bodies PRIMARY KEY (BodyID),

	CONSTRAINT UQ_Bodies_BodyName UNIQUE (BodyName)
);

INSERT INTO Bodies
SELECT DISTINCT Body FROM CarDetails ORDER BY Body;

ALTER TABLE CarDetails
ADD BodyID INT;

UPDATE CarDetails set BodyID = 
(SELECT BodyID FROM Bodies WHERE Bodies.BodyName = CarDetails.Body);

ALTER TABLE CarDetails
ADD CONSTRAINT FK_CarDetails_Bodies FOREIGN KEY 
(BodyID) REFERENCES Bodies (BodyID);

ALTER TABLE CarDetails
DROP COLUMN Body;

-------------------------------------------------------------------

-- Create a Table DriveTypes
CREATE TABLE DriveTypes (
	DriveTypeID INT IDENTITY (1, 1),
	DriveTypeName VARCHAR (50) NOT NULL,

	CONSTRAINT PK_DriveTypes PRIMARY KEY (DriveTypeID),

	CONSTRAINT UQ_DriveTypes_DriveTypeName UNIQUE (DriveTypeName)
);

INSERT INTO DriveTypes
SELECT DISTINCT Drive_Type FROM CarDetails ORDER BY Drive_Type;

ALTER TABLE CarDetails
ADD DriveTypeID INT;

UPDATE CarDetails set DriveTypeID = 
(SELECT DriveTypeID FROM DriveTypes 
WHERE DriveTypes.DriveTypeName = CarDetails.Drive_Type);

ALTER TABLE CarDetails
ADD CONSTRAINT FK_CarDetails_DriveTypes FOREIGN KEY 
(DriveTypeID) REFERENCES DriveTypes (DriveTypeID);

ALTER TABLE CarDetails
DROP COLUMN Drive_Type;

-------------------------------------------------------------------

-- Create a Table FuelTypes
CREATE TABLE FuelTypes (
	FuelTypeID INT IDENTITY (1, 1),
	FuelTypeName VARCHAR (50) NOT NULL,

	CONSTRAINT PK_FuelTypes PRIMARY KEY (FuelTypeID),

	CONSTRAINT UQ_FuelTypes_FuelTypeName UNIQUE (FuelTypeName)
);

INSERT INTO FuelTypes
SELECT DISTINCT Fuel_Type_Name FROM CarDetails ORDER BY Fuel_Type_Name;

ALTER TABLE CarDetails
ADD FuelTypeID INT;

UPDATE CarDetails set FuelTypeID = 
(SELECT FuelTypeID FROM FuelTypes 
WHERE FuelTypes.FuelTypeName = CarDetails.Fuel_Type_Name);

ALTER TABLE CarDetails
ADD CONSTRAINT FK_CarDetails_FuelTypes FOREIGN KEY 
(FuelTypeID) REFERENCES FuelTypes (FuelTypeID);

ALTER TABLE CarDetails
DROP COLUMN Fuel_Type_Name;

-------------------------------------------------------------------

-- Create a Table Models
CREATE TABLE Models (
	ModelID INT IDENTITY (1, 1),
	ModelName VARCHAR (50) NOT NULL,

	CONSTRAINT PK_Models PRIMARY KEY (ModelID),

	CONSTRAINT UQ_Models_AspirationName UNIQUE (ModelName)
);

INSERT INTO Models
SELECT DISTINCT Model FROM CarDetails ORDER BY Model;

ALTER TABLE CarDetails
ADD ModelID INT;

UPDATE CarDetails set ModelID = 
(SELECT ModelID FROM Models 
WHERE Models.ModelName = CarDetails.Model);

ALTER TABLE CarDetails
ADD CONSTRAINT FK_CarDetails_Models FOREIGN KEY 
(ModelID) REFERENCES Models (ModelID);

ALTER TABLE CarDetails
DROP COLUMN Model;

-------------------------------------------------------------------

-- Create a Table Models
CREATE TABLE SubModels (
	SubModelID INT IDENTITY (1, 1),
	SubModelName VARCHAR (50) NOT NULL,

	CONSTRAINT PK_SubModels PRIMARY KEY (SubModelID),

	CONSTRAINT UQ_SubModels_AspirationName UNIQUE (SubModelName)
);

INSERT INTO SubModels
SELECT DISTINCT SubModel FROM CarDetails ORDER BY SubModel;

ALTER TABLE CarDetails
ADD SubModelID INT;

UPDATE CarDetails set SubModelID = 
(SELECT SubModelID FROM SubModels 
WHERE SubModels.SubModelName = CarDetails.SubModel);

ALTER TABLE CarDetails
ADD CONSTRAINT FK_CarDetails_SubModels FOREIGN KEY 
(SubModelID) REFERENCES SubModels (SubModelID);

ALTER TABLE CarDetails
DROP COLUMN SubModel;