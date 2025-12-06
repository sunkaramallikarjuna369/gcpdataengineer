-- BigQuery Basics - SQL Lab 2: JOINs and Subqueries
-- ==================================================
-- This lab covers joining tables and using subqueries

-- ============================================
-- SECTION 1: Self-Joins
-- ============================================

-- Query 1: Compare name popularity across years using self-join
WITH names_2010 AS (
    SELECT name, SUM(number) as count_2010
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2010 AND gender = 'F'
    GROUP BY name
),
names_2020 AS (
    SELECT name, SUM(number) as count_2020
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2020 AND gender = 'F'
    GROUP BY name
)
SELECT 
    n2010.name,
    n2010.count_2010,
    n2020.count_2020,
    n2020.count_2020 - n2010.count_2010 AS change,
    ROUND((n2020.count_2020 - n2010.count_2010) * 100.0 / n2010.count_2010, 2) AS pct_change
FROM names_2010 n2010
INNER JOIN names_2020 n2020 ON n2010.name = n2020.name
WHERE n2010.count_2010 > 5000
ORDER BY pct_change DESC
LIMIT 20;

-- ============================================
-- SECTION 2: Subqueries in WHERE
-- ============================================

-- Query 2: Find names more popular than average
SELECT 
    name,
    SUM(number) as total_count
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020
GROUP BY name
HAVING SUM(number) > (
    SELECT AVG(total) 
    FROM (
        SELECT SUM(number) as total
        FROM `bigquery-public-data.usa_names.usa_1910_current`
        WHERE year = 2020
        GROUP BY name
    )
)
ORDER BY total_count DESC;

-- Query 3: Find the most popular name in each state
SELECT state, name, number
FROM `bigquery-public-data.usa_names.usa_1910_current` t1
WHERE year = 2020 
  AND gender = 'F'
  AND number = (
    SELECT MAX(number)
    FROM `bigquery-public-data.usa_names.usa_1910_current` t2
    WHERE t2.year = 2020 
      AND t2.gender = 'F'
      AND t2.state = t1.state
  )
ORDER BY state;

-- ============================================
-- SECTION 3: Subqueries in FROM (Derived Tables)
-- ============================================

-- Query 4: Analyze name trends by decade
SELECT 
    decade,
    COUNT(DISTINCT name) as unique_names,
    SUM(total_births) as total_births
FROM (
    SELECT 
        CAST(FLOOR(year / 10) * 10 AS INT64) as decade,
        name,
        SUM(number) as total_births
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    GROUP BY decade, name
) subquery
GROUP BY decade
ORDER BY decade;

-- ============================================
-- SECTION 4: Correlated Subqueries
-- ============================================

-- Query 5: Find names that rank in top 10 in at least 40 states
SELECT 
    name,
    COUNT(*) as states_in_top_10
FROM (
    SELECT 
        state,
        name,
        number,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY number DESC) as rank
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2020 AND gender = 'F'
) ranked
WHERE rank <= 10
GROUP BY name
HAVING COUNT(*) >= 40
ORDER BY states_in_top_10 DESC;

-- ============================================
-- SECTION 5: EXISTS and NOT EXISTS
-- ============================================

-- Query 6: Find names that existed in 1920 but not in 2020
SELECT DISTINCT name
FROM `bigquery-public-data.usa_names.usa_1910_current` old_names
WHERE year = 1920
  AND gender = 'F'
  AND NOT EXISTS (
    SELECT 1
    FROM `bigquery-public-data.usa_names.usa_1910_current` new_names
    WHERE new_names.year = 2020
      AND new_names.gender = 'F'
      AND new_names.name = old_names.name
  )
ORDER BY name
LIMIT 50;

-- Query 7: Find names that appear in both 1920 and 2020
SELECT DISTINCT name
FROM `bigquery-public-data.usa_names.usa_1910_current` old_names
WHERE year = 1920
  AND gender = 'F'
  AND EXISTS (
    SELECT 1
    FROM `bigquery-public-data.usa_names.usa_1910_current` new_names
    WHERE new_names.year = 2020
      AND new_names.gender = 'F'
      AND new_names.name = old_names.name
  )
ORDER BY name
LIMIT 50;

-- ============================================
-- SECTION 6: UNION, INTERSECT, EXCEPT
-- ============================================

-- Query 8: UNION - Combine results from different queries
SELECT name, 'Top in 2010' as category
FROM (
    SELECT name, SUM(number) as total
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2010 AND gender = 'F'
    GROUP BY name
    ORDER BY total DESC
    LIMIT 10
)
UNION ALL
SELECT name, 'Top in 2020' as category
FROM (
    SELECT name, SUM(number) as total
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2020 AND gender = 'F'
    GROUP BY name
    ORDER BY total DESC
    LIMIT 10
);

-- Query 9: INTERSECT - Names in top 10 for both years
SELECT name FROM (
    SELECT name
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2010 AND gender = 'F'
    GROUP BY name
    ORDER BY SUM(number) DESC
    LIMIT 10
)
INTERSECT DISTINCT
SELECT name FROM (
    SELECT name
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2020 AND gender = 'F'
    GROUP BY name
    ORDER BY SUM(number) DESC
    LIMIT 10
);

-- Query 10: EXCEPT - Names in 2010 top 10 but not 2020 top 10
SELECT name FROM (
    SELECT name
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2010 AND gender = 'F'
    GROUP BY name
    ORDER BY SUM(number) DESC
    LIMIT 10
)
EXCEPT DISTINCT
SELECT name FROM (
    SELECT name
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2020 AND gender = 'F'
    GROUP BY name
    ORDER BY SUM(number) DESC
    LIMIT 10
);

-- ============================================
-- PRACTICE EXERCISES
-- ============================================

-- Exercise 1: Find names that increased in popularity by more than 500% from 2000 to 2020
-- Your query here:


-- Exercise 2: For each year, find the name that had the biggest increase from the previous year
-- Your query here:


-- Exercise 3: Find "comeback" names - popular in 1950s, unpopular in 1990s, popular again in 2010s
-- Your query here:
