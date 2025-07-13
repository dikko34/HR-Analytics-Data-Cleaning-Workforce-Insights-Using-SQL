


--Data needs cleaning (Swap vlaues in the Hire & lastPromoted Columns)
---Some Rows have the HireDate and LastPrmotionDate Values Swapped

WITH Difference_CTE AS(
SELECT *,DATEDIFF(YEAR,HireDate,LastPromotionDate)Difference
FROM [HR Analytics]
)
SELECT *
FROM Difference_CTE
WHERE Difference <0;


--Creating New Table to Work on

CREATE TABLE [dbo].[HR Analytics_Cleaned](
	[EmployeeID] [nvarchar](255) NULL,
	[Department] [nvarchar](255) NULL,
	[Gender] [nvarchar](255) NULL,
	[EducationLevel] [nvarchar](255) NULL,
	[YearsAtCompany] [float] NULL,
	[MonthlySalary] [float] NULL,
	[PerformanceRating] [float] NULL,
	[JobSatisfaction] [float] NULL,
	[Attrition] [nvarchar](255) NULL,
	[LastPromotionDate] [datetime] NULL,
	[HireDate] [datetime] NULL,
	[OverTime] [nvarchar](255) NULL,
	[RecruitmentSource] [nvarchar](255) NULL
) ON [PRIMARY]

INSERT INTO [HR Analytics_Cleaned]
SELECT *
FROM [HR Analytics];

--- Identifying Swapped Rows
SELECT *
FROM [HR Analytics_Cleaned]
WHERE HireDate > LastPromotionDate


--- Converting Swapped Rows to Null Values

UPDATE [HR Analytics_Cleaned]
SET LastPromotionDate = NULL
WHERE HireDate > LastPromotionDate

SELECT *
FROM [HR Analytics_Cleaned]
WHERE LastPromotionDate IS NULL


UPDATE [HR Analytics_Cleaned]
SET HireDate = NULL
WHERE LastPromotionDate IS NULL

SELECT *
FROM [HR Analytics_Cleaned]
WHERE HireDate IS NULL


--- Performing a Join with HR Analytics Dataset in other to Replace NULL Values

SELECT HR1.LastPromotionDate,HR1.HireDate,HR2.LastPromotionDate, HR2.HireDate, 
		ISNULL(HR1.LastPromotionDate,Hr2.HireDate)LastPromotedDate_Updated,
		ISNULL(HR1.HireDate,HR2.LastPromotionDate)HireDate_Updated
FROM [HR Analytics_Cleaned] HR1
JOIN [HR Analytics] HR2
	ON HR1.EmployeeID = HR2.EmployeeID
WHERE HR1.LastPromotionDate IS NULL


--- Updating Null LastpromotedDate & HireDate Rows With Correct Values

--Updating Null values in the LastPromoted_Date Column
UPDATE [HR Analytics_Cleaned]
SET LastPromotionDate = ISNULL(HR1.LastPromotionDate,Hr2.HireDate)
FROM [HR Analytics_Cleaned] HR1
JOIN [HR Analytics] HR2
	ON HR1.EmployeeID = HR2.EmployeeID
WHERE HR1.LastPromotionDate IS NULL


--Updating Null values in the Hired_Date Column
UPDATE [HR Analytics_Cleaned]
SET HireDate = ISNULL(HR1.HireDate,HR2.LastPromotionDate)
FROM [HR Analytics_Cleaned] HR1
JOIN [HR Analytics] HR2
	ON HR1.EmployeeID = HR2.EmployeeID
WHERE HR1.HireDate IS NULL


SELECT *
FROM [HR Analytics_Cleaned]
WHERE HireDate > LastPromotionDate