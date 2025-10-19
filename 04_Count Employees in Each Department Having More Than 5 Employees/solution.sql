-- Question 4: Count Employees in Each Department Having More Than 5 Employees
-- Difficulty: Easy
-- Topic: Aggregation, GROUP BY, HAVING, CTE

-- Approach 1: GROUP BY + HAVING
SELECT department, COUNT(*) AS EmployeeCount
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

-- Approach 2: CTE
WITH DeptCount AS (
    SELECT department, COUNT(*) AS EmployeeCount
    FROM employees
    GROUP BY department
)
SELECT *
FROM DeptCount
WHERE EmployeeCount > 5;

-- Approach 3: Subquery
SELECT department, EmployeeCount
FROM (
    SELECT department, COUNT(*) AS EmployeeCount
    FROM employees
    GROUP BY department
) AS DeptSummary
WHERE EmployeeCount > 5;
