-- Question 3: Find Employees Who Earn More Than Their Manager
-- Source: LeetCode #181
-- Difficulty: Easy
-- Topic: Self Join, Subquery, CTE

-- Dummy data setup included above.

-- Approach 1: Self Join
SELECT 
    e.name AS Employee,
    e.salary AS EmployeeSalary,
    m.name AS Manager,
    m.salary AS ManagerSalary
FROM employees e
JOIN employees m 
    ON e.manager_id = m.id
WHERE e.salary > m.salary;

-- Approach 2: CTE
WITH ManagerCTE AS (
    SELECT 
        e.id,
        e.name AS Employee,
        e.salary AS EmployeeSalary,
        m.name AS Manager,
        m.salary AS ManagerSalary
    FROM employees e
    JOIN employees m 
        ON e.manager_id = m.id
)
SELECT *
FROM ManagerCTE
WHERE EmployeeSalary > ManagerSalary;

-- Approach 3: Correlated Subquery
SELECT e.name AS Employee, e.salary AS EmployeeSalary
FROM employees e
WHERE e.manager_id IS NOT NULL
  AND e.salary > (
        SELECT m.salary 
        FROM employees m
        WHERE m.id = e.manager_id
    );
