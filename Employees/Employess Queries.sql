USE EmployeesDB	;

SELECT 
	* 
FROM 
	Employees;

-------------------------------------------------------------------------

-- Get All Employees That Have Manager Along With Manager's Name.
-- Get All Employees That Have Manager Along With Manager's Name.
SELECT 
    Employees.Name,
    Employees.ManagerID,
    Managers.Name AS ManagerName,
    Employees.Salary
FROM
    Employees
JOIN 
    Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID;

-------------------------------------------------------------------------

-- Get All Employees That Have Manager Or Does Not Have Manager Along With
-- Manager's Name, Incase No ManagerName  Show Null
SELECT 
	Employees.Name,
    Employees.ManagerID,
    Managers.Name AS ManagerName,
    Employees.Salary
FROM 
	Employees
LEFT JOIN
	Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID

-------------------------------------------------------------------------

-- Get All Employees That Have Manager Or Does Not Have Manager Along With Manager's
-- Name, Incase No Manager Name The Same Employee Name As Manager To Himself
SELECT       
	Employees.Name,
	Employees.ManagerID,
	Employees.Salary,  
	CASE
		WHEN Managers.Name is Null  THEN 'CEO'
		ELSE Managers.Name
	END as ManagerName
FROM  
	Employees 
Left JOIN
	Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID;

-------------------------------------------------------------------------

-- Get All Employees Managed By 'Mohammed'
SELECT 
	Employees.Name,
	Employees.ManagerID,
	Employees.Salary  
FROM
	Employees
JOIN 
	Employees AS Managers ON Employees.ManagerID = Managers.EmployeeID
where 
	Managers.Name = 'Mohammed';

-------------------------------------------------------------------------
