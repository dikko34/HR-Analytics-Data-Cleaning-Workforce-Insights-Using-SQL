
-- 1.Employee Attrition Risk
	--Identify who is most at risk of leaving based on satisfaction, overtime, and years at company.


SELECT Attrition,ROUND(AVG(JobSatisfaction),1)Average_Satisfaction,ROUND(AVG(YearsAtCompany),1)Average_Years,OverTime
FROM [HR Analytics_Cleaned]
GROUP BY OverTime,Attrition

SELECT Attrition, ROUND(AVG(JobSatisfaction),1)Average_Satisfaction
FROM [HR Analytics_Cleaned]
GROUP BY Attrition

SELECT Attrition, COUNT(OverTime)Count
FROM [HR Analytics_Cleaned]
GROUP BY Attrition

SELECT Attrition, ROUND(AVG(YearsAtCompany),1)Average_Years
FROM [HR Analytics_Cleaned]
GROUP BY Attrition;

--2. Salary vs Performance
	-- Are top performers being compensated fairly?
	-- Is there a mismatch between pay and performance?

WITH Performance_GROUP_CTE AS
(
SELECT *,
CASE
	WHEN PerformanceRating >=4 THEN 'Top_Performer'
	WHEN PerformanceRating >=2 THEN 'Average_Performer'
	ELSE 'Low_Performer'
END Perfromance_Group
FROM [HR Analytics_Cleaned]
)
SELECT Perfromance_Group,AVG(MonthlySalary) Average_Salary
FROM Performance_GROUP_CTE
GROUP BY Perfromance_Group
ORDER BY Average_Salary DESC


--3.Promotion & Career Growth
	-- Who has been promoted?
	-- Are certain groups under-promoted despite tenure?

-- Who has been promoted?
WITH Difference_CTE AS
(
SELECT *,DATEDIFF(YEAR,HireDate,LastPromotionDate)Years_SinceLastPromotion 
FROM [HR Analytics_Cleaned]
), Correct_Differences AS
(
SELECT *
FROM Difference_CTE
)
SELECT EmployeeID,Years_SinceLastPromotion
FROM Correct_Differences
WHERE Years_SinceLastPromotion <= 2


-- Are certain groups under-promoted despite tenure?

--Gender
WITH Difference_CTE AS
(
SELECT *,DATEDIFF(YEAR,HireDate,LastPromotionDate)Years_SinceLastPromotion 
FROM [HR Analytics_Cleaned]
)
SELECT Gender,AVG(Years_SinceLastPromotion)Average_Years_SincePromotion,ROUND(AVG(YearsAtCompany),1)Average_Years_Incompany
FROM Difference_CTE
GROUP BY Gender
ORDER BY Average_Years_Incompany DESC


--EducationLevel
WITH Difference_CTE AS
(
SELECT *,DATEDIFF(YEAR,HireDate,LastPromotionDate)Years_SinceLastPromotion 
FROM [HR Analytics_Cleaned]
)
SELECT EducationLevel,AVG(Years_SinceLastPromotion)Average_Years_SincePromotion,ROUND(AVG(YearsAtCompany),1)Average_Years_Incompany
FROM Difference_CTE
GROUP BY EducationLevel
ORDER BY Average_Years_Incompany DESC



--4. Hiring Funnel Efficiency
	-- What recruitment sources bring the best hires?
	-- Where are delays or drop-offs happening?

-- What recruitment sources bring the best hires?
SELECT RecruitmentSource,
		COUNT(*)Total_Hire,
		ROUND(AVG(PerformanceRating),1)Average_PerformaceRating,
		ROUND(AVG(MonthlySalary),1)Average_Salary,
		AVG(YearsAtCompany)Tenure
FROM [HR Analytics_Cleaned]
GROUP BY RecruitmentSource

-- Where are delays or drop-offs happening?

SELECT RecruitmentSource,AVG(DATEDIFF(YEAR,HireDate,LastPromotionDate))Years_SinceLastPromotion,
									SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*) AttritionRate
FROM [HR Analytics_Cleaned]
GROUP BY RecruitmentSource

--5. Diversity & Inclusion Metrics
	-- Are there pay gaps by gender or education?
	-- Is representation fair across departments?

-- Are there pay gaps by gender or education?
SELECT Gender,ROUND(AVG(CASE WHEN EducationLevel = 'Bachelor' THEN MonthlySalary ELSE 0 END),1) Average_Bachelor_Salary,
				ROUND(AVG(CASE WHEN EducationLevel = 'High School' THEN MonthlySalary ELSE 0 END),1)Average_HighSchooler_Salary,
				ROUND(AVG(CASE WHEN EducationLevel = 'Master' THEN MonthlySalary ELSE 0 END),1)Average_Masters_Salary,
				ROUND(AVG(CASE WHEN EducationLevel = 'PHD' THEN MonthlySalary ELSE 0 END),1)Average_PHD_Salary
FROM [HR Analytics_Cleaned]
GROUP BY Gender


-- Is representation fair across departments?
SELECT DISTINCT(Department),SUM(CASE WHEN EducationLevel = 'Bachelor' THEN 1 ELSE 0 END)* 100.0/ COUNT(*) PercentageOf_Bachelors_Hire,
							SUM(CASE WHEN EducationLevel = 'High School' THEN 1 ELSE 0 END)* 100.0/ COUNT(*) PercentageOf_HighSchool_Hire,
							SUM(CASE WHEN EducationLevel = 'Master' THEN 1 ELSE 0 END)* 100.0/ COUNT(*) PercentageOf_Master_Hire,
							SUM(CASE WHEN EducationLevel = 'PHD' THEN 1 ELSE 0 END)* 100.0/ COUNT(*) PercenatageOf_PHD_Hire
FROM [HR Analytics_Cleaned]
GROUP BY Department


SELECT *
FROM [HR Analytics_Cleaned];


