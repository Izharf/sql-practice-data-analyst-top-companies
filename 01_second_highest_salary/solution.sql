-- Question 1: Second Highest Salary
-- Source: LeetCode #176
-- Difficulty: Easy
-- Topic: Subquery, Aggregation

-- Problem: Find the second highest salary from employees table.
-- If no second highest, return NULL.

SELECT MAX(salary) AS SecondHighestSalary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Explanation:
-- 1. Inner query finds the highest salary.
-- 2. Outer query finds the max salary that’s smaller than that.
-- This ensures we skip the top salary and get the next one.
