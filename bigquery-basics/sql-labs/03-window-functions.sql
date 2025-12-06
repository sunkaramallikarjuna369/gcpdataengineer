-- BigQuery Basics - SQL Lab 3: Window Functions
-- ==============================================
-- This lab covers advanced window functions in BigQuery

-- ============================================
-- SECTION 1: ROW_NUMBER, RANK, DENSE_RANK
-- ============================================

-- Query 1: Basic ranking functions comparison
WITH sample_data AS (
    SELECT 'Alice' as name, 100 as score UNION ALL
    SELECT 'Bob', 95 UNION ALL
    SELECT 'Charlie', 95 UNION ALL
    SELECT 'Diana', 90 UNION ALL
    SELECT 'Eve', 85
)
SELECT 
    name,
    score,
    ROW_NUMBER() OVER (ORDER BY score DESC) as row_num,
    RANK() OVER (ORDER BY score DESC) as rank,
    DENSE_RANK() OVER (ORDER BY score DESC) as dense_rank
FROM sample_data;

-- Query 2: Top 3 names per state
SELECT *
FROM (
    SELECT 
        state,
        name,
        number,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY number DESC) as rank
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2020 AND gender = 'F'
)
WHERE rank <= 3
ORDER BY state, rank;

-- Query 3: Percentile ranking
SELECT 
    name,
    total_count,
    PERCENT_RANK() OVER (ORDER BY total_count) as percentile,
    NTILE(4) OVER (ORDER BY total_count) as quartile
FROM (
    SELECT name, SUM(number) as total_count
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year = 2020 AND gender = 'F'
    GROUP BY name
)
ORDER BY total_count DESC
LIMIT 100;

-- ============================================
-- SECTION 2: LAG and LEAD
-- ============================================

-- Query 4: Year-over-year change for a specific name
SELECT 
    year,
    total_count,
    LAG(total_count, 1) OVER (ORDER BY year) as prev_year,
    total_count - LAG(total_count, 1) OVER (ORDER BY year) as yoy_change,
    ROUND(
        (total_count - LAG(total_count, 1) OVER (ORDER BY year)) * 100.0 / 
        LAG(total_count, 1) OVER (ORDER BY year), 
        2
    ) as yoy_pct_change
FROM (
    SELECT year, SUM(number) as total_count
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE name = 'Emma' AND gender = 'F'
    GROUP BY year
)
ORDER BY year;

-- Query 5: Compare with previous and next values
SELECT 
    year,
    total_count,
    LAG(total_count, 1) OVER (ORDER BY year) as prev_year,
    LEAD(total_count, 1) OVER (ORDER BY year) as next_year,
    CASE 
        WHEN total_count > LAG(total_count, 1) OVER (ORDER BY year) 
             AND total_count > LEAD(total_count, 1) OVER (ORDER BY year)
        THEN 'Peak'
        WHEN total_count < LAG(total_count, 1) OVER (ORDER BY year) 
             AND total_count < LEAD(total_count, 1) OVER (ORDER BY year)
        THEN 'Valley'
        ELSE 'Normal'
    END as trend_point
FROM (
    SELECT year, SUM(number) as total_count
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE name = 'Jennifer' AND gender = 'F'
    GROUP BY year
)
WHERE year >= 1960
ORDER BY year;

-- ============================================
-- SECTION 3: Running Totals and Averages
-- ============================================

-- Query 6: Cumulative sum
SELECT 
    year,
    total_births,
    SUM(total_births) OVER (ORDER BY year) as cumulative_total,
    SUM(total_births) OVER (ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM (
    SELECT year, SUM(number) as total_births
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE name = 'Emma' AND gender = 'F'
    GROUP BY year
)
WHERE year >= 2000
ORDER BY year;

-- Query 7: Moving average
SELECT 
    year,
    total_births,
    ROUND(AVG(total_births) OVER (
        ORDER BY year 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 0) as moving_avg_3yr,
    ROUND(AVG(total_births) OVER (
        ORDER BY year 
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ), 0) as moving_avg_5yr
FROM (
    SELECT year, SUM(number) as total_births
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE name = 'Emma' AND gender = 'F'
    GROUP BY year
)
WHERE year >= 1990
ORDER BY year;

-- ============================================
-- SECTION 4: FIRST_VALUE, LAST_VALUE, NTH_VALUE
-- ============================================

-- Query 8: First and last values in partition
SELECT 
    state,
    name,
    number,
    FIRST_VALUE(name) OVER (PARTITION BY state ORDER BY number DESC) as most_popular,
    LAST_VALUE(name) OVER (
        PARTITION BY state 
        ORDER BY number DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as least_popular
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020 AND gender = 'F'
QUALIFY ROW_NUMBER() OVER (PARTITION BY state ORDER BY number DESC) <= 5
ORDER BY state, number DESC;

-- Query 9: NTH_VALUE - Get specific ranked value
SELECT DISTINCT
    state,
    FIRST_VALUE(name) OVER w as rank_1,
    NTH_VALUE(name, 2) OVER w as rank_2,
    NTH_VALUE(name, 3) OVER w as rank_3
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020 AND gender = 'F'
WINDOW w AS (
    PARTITION BY state 
    ORDER BY number DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY state
LIMIT 20;

-- ============================================
-- SECTION 5: Window Frame Specifications
-- ============================================

-- Query 10: Different window frames
SELECT 
    year,
    total_births,
    -- All rows in partition
    SUM(total_births) OVER () as grand_total,
    -- From start to current row
    SUM(total_births) OVER (ORDER BY year ROWS UNBOUNDED PRECEDING) as running_total,
    -- Current row and 2 preceding
    SUM(total_births) OVER (ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as last_3_years,
    -- 1 preceding to 1 following (centered)
    AVG(total_births) OVER (ORDER BY year ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as centered_avg
FROM (
    SELECT year, SUM(number) as total_births
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE name = 'Emma' AND gender = 'F'
    GROUP BY year
)
WHERE year >= 2010
ORDER BY year;

-- ============================================
-- SECTION 6: Named Windows
-- ============================================

-- Query 11: Using WINDOW clause for reusable definitions
SELECT 
    year,
    name,
    total_count,
    SUM(total_count) OVER yearly_window as year_total,
    ROUND(total_count * 100.0 / SUM(total_count) OVER yearly_window, 2) as pct_of_year,
    RANK() OVER yearly_rank as rank
FROM (
    SELECT year, name, SUM(number) as total_count
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE year IN (2018, 2019, 2020) AND gender = 'F'
    GROUP BY year, name
)
WINDOW 
    yearly_window AS (PARTITION BY year),
    yearly_rank AS (PARTITION BY year ORDER BY total_count DESC)
QUALIFY rank <= 5
ORDER BY year, rank;

-- ============================================
-- SECTION 7: QUALIFY Clause (BigQuery specific)
-- ============================================

-- Query 12: Filter on window function results with QUALIFY
SELECT 
    state,
    name,
    number,
    RANK() OVER (PARTITION BY state ORDER BY number DESC) as rank
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020 AND gender = 'F'
QUALIFY RANK() OVER (PARTITION BY state ORDER BY number DESC) = 1
ORDER BY state;

-- ============================================
-- PRACTICE EXERCISES
-- ============================================

-- Exercise 1: Find names that were #1 in popularity for at least 5 consecutive years
-- Hint: Use LAG to check previous year's rank
-- Your query here:


-- Exercise 2: Calculate the 5-year moving average of total births per year
-- Your query here:


-- Exercise 3: For each name, find the year it was most popular and least popular
-- Your query here:
