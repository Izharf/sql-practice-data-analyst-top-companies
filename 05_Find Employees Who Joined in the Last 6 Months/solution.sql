-- Question 5: Find Employees Who Joined in the Last 6 Months
-- Source: Common Interview SQL Question
-- Difficulty: Easy
-- Topic: Date Filtering, DATEADD, GETDATE

-- Approach 1: Using DATEADD() with GETDATE()
SELECT *
FROM employees
WHERE join_date >= DATEADD(MONTH, -6, GETDATE());

-- Approach 2: Using DATEADD() with CAST for Date-Only Comparison
SELECT *
FROM employees
WHERE join_date >= DATEADD(MONTH, -6, CAST(GETDATE() AS DATE));

-- Approach 3: Using Fixed Date for Reproducible Testing
DECLARE @Today DATE = '2024-10-18';
SELECT *
FROM employees
WHERE join_date >= DATEADD(MONTH, -6, @Today);
