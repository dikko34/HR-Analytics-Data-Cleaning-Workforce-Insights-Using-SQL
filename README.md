# Project: HR Analytics — Data Cleaning & Workforce Insights Using SQL

## Problem Statement / Business Context
The HR department provided a dataset containing inconsistencies, particularly swapped dates between HireDate and LastPromotionDate. After cleaning, the goal was to analyze workforce trends, assess attrition risks, evaluate promotion fairness, and uncover diversity insights.

## Objectives / Analysis Performed

### Phase 1: Data Cleaning
- Identified rows with swapped HireDate and LastPromotionDate
- Created a clean working table (HR Analytics_Cleaned)
- Replaced incorrect date values by referencing original dataset

### Phase 2: Workforce Analytics
**1. Employee Attrition Risk:**  
Analyzed how employee satisfaction, overtime workload, and years at the company affect attrition rates. This helped identify which employee groups are more likely to leave the company.

**2. Salary vs Performance Evaluation:**  
Evaluated whether top-performing employees were being paid fairly. Grouped performance levels and calculated average salaries to detect imbalances.

**3. Promotion & Career Growth Patterns:**  
Measured the time since last promotion and compared it against tenure. This revealed whether certain groups (e.g., by gender or education level) were being overlooked for promotion.

**4. Hiring Funnel Efficiency:**  
Assessed recruitment channels by comparing new hire performance, tenure, and attrition. Helped determine which sources yield high-quality, long-term employees.

**5. Diversity & Inclusion Metrics:**  
Explored salary gaps and education representation across departments and genders to evaluate fairness and inclusivity in pay and hiring practices.

## Dataset Description
**Tables:**
- HR Analytics: Original, uncleaned dataset  
- HR Analytics_Cleaned: Cleaned version used for analysis

**Key Columns:**
- EmployeeID, Gender, Department, EducationLevel, HireDate, LastPromotionDate,  
  MonthlySalary, YearsAtCompany, Attrition, PerformanceRating, JobSatisfaction, OverTime, RecruitmentSource

## Tools & SQL Concepts Used
- SQL Server  
- Data Cleaning: `ISNULL()`, `UPDATE`, `JOIN`  
- Analysis: `GROUP BY`, `CASE WHEN`, `AVG()`, `COUNT()`, `DATEDIFF()`  
- Window Functions: `WITH` CTEs

## Sample SQL Snippets

### Identifying Swapped Dates (Data Cleaning)
```sql
SELECT *
FROM [HR Analytics]
WHERE DATEDIFF(YEAR, HireDate, LastPromotionDate) < 0
```
#### Attrition Risk by Overtime & Satisfaction

```sql
SELECT Attrition, 
       ROUND(AVG(JobSatisfaction), 1) AS Avg_Satisfaction,
       ROUND(AVG(YearsAtCompany), 1) AS Avg_Years, 
       OverTime
FROM [HR Analytics_Cleaned]
GROUP BY OverTime, Attrition;
```
### Salary vs. Performance Group
``` sql
Copy
Edit
WITH Performance_GROUP_CTE AS (
    SELECT *, 
           CASE 
               WHEN PerformanceRating >= 4 THEN 'Top_Performer'
               WHEN PerformanceRating >= 2 THEN 'Average_Performer'
               ELSE 'Low_Performer'
           END AS Performance_Group
    FROM [HR Analytics_Cleaned]
)
SELECT Performance_Group, 
       AVG(MonthlySalary) AS Average_Salary
FROM Performance_GROUP_CTE
GROUP BY Performance_Group
ORDER BY Average_Salary DESC;
```

### Insights / Outcomes

- **Data Integrity Restored**: Swapped `HireDate` and `LastPromotionDate` values were corrected without data loss by referencing original records.

- **Attrition Analysis** showed that employees with low satisfaction and overtime workload are more likely to leave, especially with shorter tenure.

- **Top performers were underpaid** in some cases, highlighting a potential reward imbalance.

- **Promotion gaps** were more visible across certain genders and education levels, suggesting room for equitable policy review.

- **Recruitment sources** varied in terms of performance and retention — some led to high attrition despite strong hiring numbers.

- **Diversity analysis** uncovered education representation gaps across departments and salary discrepancies between genders with similar qualifications.
