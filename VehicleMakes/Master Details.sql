CREATE VIEW MasterDetails AS
	SELECT 
		VH.ID,
		MK.Make,
		MD.ModelName,
		SM.SubModelName, 
		BD.BodyName,
		VH.Vehicle_Display_Name,
		VH.Year,
		DT.DriveTypeName,
		VH.Engine,
		VH.Engine_CC,
		VH.Engine_Cylinders,
		VH.Engine_Liter_Display,
		FT.FuelTypeName,
		VH.NumDoors
	FROM 
		VehicleDetails VH 
	JOIN 	
		Makes MK ON VH.MakeID = MK.MakeID 
	JOIN
		MakeModels MD ON VH.ModelID = MD.ModelID
	JOIN 
		SubModels SM ON VH.SubModelID = SM.SubModelID
	JOIN 
		Bodies BD ON VH.BodyID = BD.BodyID
	JOIN 
		DriveTypes DT ON VH.DriveTypeID = DT.DriveTypeID
	JOIN 
		FuelTypes FT ON VH.FuelTypeID = FT.FuelTypeID;





