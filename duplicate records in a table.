-- Question 2: Find Duplicate Records in a Table
-- Source: Common Interview SQL Question
-- Difficulty: Easy
-- Topic: GROUP BY, HAVING, Window Functions, Self Join

-- Approach 1: GROUP BY + HAVING
SELECT name, COUNT(*) AS occurrence_count
FROM employees
GROUP BY name
HAVING COUNT(*) > 1;

-- Approach 2: Window Function
SELECT id, name, department, salary
FROM (
    SELECT *,
           COUNT(*) OVER (PARTITION BY name) AS cnt
    FROM employees
) AS temp
WHERE cnt > 1;

-- Approach 3: Self Join
SELECT DISTINCT e1.name
FROM employees e1
JOIN employees e2
  ON e1.name = e2.name
 AND e1.id <> e2.id;
