-- BigQuery Basics - SQL Lab 1: Basic Queries
-- ============================================
-- This lab covers fundamental SQL operations in BigQuery

-- ============================================
-- SECTION 1: SELECT Basics
-- ============================================

-- Query 1: Simple SELECT
-- Get all columns from a table (avoid in production - costly!)
SELECT *
FROM `bigquery-public-data.usa_names.usa_1910_current`
LIMIT 10;

-- Query 2: Select specific columns (best practice)
SELECT 
    name,
    year,
    gender,
    number
FROM `bigquery-public-data.usa_names.usa_1910_current`
LIMIT 10;

-- Query 3: Column aliases
SELECT 
    name AS baby_name,
    year AS birth_year,
    number AS count
FROM `bigquery-public-data.usa_names.usa_1910_current`
LIMIT 10;

-- ============================================
-- SECTION 2: WHERE Clause - Filtering Data
-- ============================================

-- Query 4: Simple filter
SELECT name, year, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
LIMIT 10;

-- Query 5: Multiple conditions with AND
SELECT name, year, gender, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
  AND gender = 'F'
  AND number > 10000
ORDER BY number DESC;

-- Query 6: OR conditions
SELECT name, year, state, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
  AND (state = 'CA' OR state = 'TX' OR state = 'NY')
ORDER BY number DESC
LIMIT 20;

-- Query 7: IN operator (cleaner than multiple ORs)
SELECT name, year, state, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
  AND state IN ('CA', 'TX', 'NY', 'FL')
ORDER BY number DESC
LIMIT 20;

-- Query 8: BETWEEN for ranges
SELECT name, year, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year BETWEEN 2015 AND 2020
  AND name = 'Emma'
ORDER BY year;

-- Query 9: LIKE for pattern matching
SELECT DISTINCT name
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE name LIKE 'A%'  -- Names starting with A
  AND year = 2020
ORDER BY name
LIMIT 20;

-- Query 10: NOT operator
SELECT name, year, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
  AND gender = 'M'
  AND name NOT IN ('Liam', 'Noah', 'Oliver')
ORDER BY number DESC
LIMIT 10;

-- ============================================
-- SECTION 3: ORDER BY - Sorting Results
-- ============================================

-- Query 11: Single column sort
SELECT name, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020 AND gender = 'F'
ORDER BY number DESC
LIMIT 10;

-- Query 12: Multiple column sort
SELECT state, name, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020 AND gender = 'F'
ORDER BY state ASC, number DESC
LIMIT 50;

-- ============================================
-- SECTION 4: Aggregate Functions
-- ============================================

-- Query 13: COUNT
SELECT COUNT(*) AS total_records
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020;

-- Query 14: COUNT DISTINCT
SELECT 
    COUNT(DISTINCT name) AS unique_names,
    COUNT(DISTINCT state) AS unique_states
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020;

-- Query 15: SUM, AVG, MIN, MAX
SELECT 
    SUM(number) AS total_births,
    AVG(number) AS avg_per_record,
    MIN(number) AS min_count,
    MAX(number) AS max_count
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020;

-- ============================================
-- SECTION 5: GROUP BY
-- ============================================

-- Query 16: Simple GROUP BY
SELECT 
    gender,
    SUM(number) AS total_births
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
GROUP BY gender;

-- Query 17: GROUP BY with multiple columns
SELECT 
    state,
    gender,
    SUM(number) AS total_births
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
GROUP BY state, gender
ORDER BY state, gender;

-- Query 18: Top names by total count
SELECT 
    name,
    SUM(number) AS total_count
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year >= 2010
GROUP BY name
ORDER BY total_count DESC
LIMIT 20;

-- ============================================
-- SECTION 6: HAVING - Filter Aggregated Results
-- ============================================

-- Query 19: HAVING clause
SELECT 
    name,
    SUM(number) AS total_count
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
GROUP BY name
HAVING SUM(number) > 50000
ORDER BY total_count DESC;

-- Query 20: HAVING with COUNT
SELECT 
    name,
    COUNT(DISTINCT state) AS num_states,
    SUM(number) AS total_count
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
GROUP BY name
HAVING COUNT(DISTINCT state) = 51  -- All states + DC
ORDER BY total_count DESC
LIMIT 20;

-- ============================================
-- PRACTICE EXERCISES
-- ============================================

-- Exercise 1: Find the top 5 female names in California for 2020
-- Your query here:


-- Exercise 2: Count how many unique names were used in each decade
-- Hint: Use FLOOR(year/10)*10 to get decade
-- Your query here:


-- Exercise 3: Find states where 'Emma' was the most popular female name in 2020
-- Your query here:
