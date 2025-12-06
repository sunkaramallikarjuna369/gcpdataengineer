# Exercise: Query Optimization

## Difficulty: Medium
## Time: 30 minutes

## Objective
Learn to optimize BigQuery queries for cost and performance.

## Prerequisites
- Completed BigQuery basics labs
- Understanding of SQL fundamentals

## Scenario

You're a data engineer at a company that's spending too much on BigQuery. Your task is to optimize several queries to reduce costs while maintaining functionality.

## Exercise 1: Column Selection

**Bad Query (Don't run this!):**
```sql
SELECT *
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020;
```

**Task:** Rewrite this query to only select the columns needed: name, gender, and number.

**Your Solution:**
```sql
-- Write your optimized query here
```

**Expected Savings:** ~40% reduction in bytes processed

## Exercise 2: Filter Early

**Bad Query:**
```sql
SELECT 
    name,
    SUM(number) as total
FROM `bigquery-public-data.usa_names.usa_1910_current`
GROUP BY name
HAVING SUM(number) > 1000000;
```

**Task:** This query processes all years but we only need 2010-2020. Add a WHERE clause to filter early.

**Your Solution:**
```sql
-- Write your optimized query here
```

## Exercise 3: Avoid Repeated Scans

**Bad Query:**
```sql
SELECT 
    (SELECT SUM(number) FROM `bigquery-public-data.usa_names.usa_1910_current` WHERE year = 2020) as total_2020,
    (SELECT SUM(number) FROM `bigquery-public-data.usa_names.usa_1910_current` WHERE year = 2019) as total_2019,
    (SELECT SUM(number) FROM `bigquery-public-data.usa_names.usa_1910_current` WHERE year = 2018) as total_2018;
```

**Task:** Rewrite using a single scan with conditional aggregation.

**Your Solution:**
```sql
-- Write your optimized query here
-- Hint: Use SUM(IF(year = 2020, number, 0))
```

## Exercise 4: Use Approximate Functions

**Original Query:**
```sql
SELECT COUNT(DISTINCT name) as unique_names
FROM `bigquery-public-data.usa_names.usa_1910_current`;
```

**Task:** For large datasets, exact distinct counts are expensive. Rewrite using `APPROX_COUNT_DISTINCT`.

**Your Solution:**
```sql
-- Write your optimized query here
```

## Exercise 5: Dry Run Analysis

Use dry run to compare the cost of your optimized queries:

```python
from google.cloud import bigquery

client = bigquery.Client()

def estimate_cost(query):
    job_config = bigquery.QueryJobConfig(dry_run=True, use_query_cache=False)
    job = client.query(query, job_config=job_config)
    mb_processed = job.total_bytes_processed / 1e6
    cost = job.total_bytes_processed / 1e12 * 5  # $5 per TB
    return mb_processed, cost

# Test your queries
original_query = "SELECT * FROM ..."
optimized_query = "SELECT name, number FROM ..."

orig_mb, orig_cost = estimate_cost(original_query)
opt_mb, opt_cost = estimate_cost(optimized_query)

print(f"Original: {orig_mb:.2f} MB, ${orig_cost:.6f}")
print(f"Optimized: {opt_mb:.2f} MB, ${opt_cost:.6f}")
print(f"Savings: {(1 - opt_mb/orig_mb)*100:.1f}%")
```

## Solutions

<details>
<summary>Click to reveal solutions</summary>

### Exercise 1 Solution:
```sql
SELECT name, gender, number
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year = 2020;
```

### Exercise 2 Solution:
```sql
SELECT 
    name,
    SUM(number) as total
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year BETWEEN 2010 AND 2020
GROUP BY name
HAVING SUM(number) > 1000000;
```

### Exercise 3 Solution:
```sql
SELECT 
    SUM(IF(year = 2020, number, 0)) as total_2020,
    SUM(IF(year = 2019, number, 0)) as total_2019,
    SUM(IF(year = 2018, number, 0)) as total_2018
FROM `bigquery-public-data.usa_names.usa_1910_current`
WHERE year IN (2018, 2019, 2020);
```

### Exercise 4 Solution:
```sql
SELECT APPROX_COUNT_DISTINCT(name) as approx_unique_names
FROM `bigquery-public-data.usa_names.usa_1910_current`;
```

</details>

## Interview Question

**Q: What are the main ways to optimize BigQuery query costs?**

A: Key optimization strategies include:
1. Select only needed columns (avoid SELECT *)
2. Filter early with WHERE clauses
3. Use partitioned and clustered tables
4. Leverage query caching
5. Use approximate aggregation functions for large datasets
6. Avoid repeated table scans
7. Use materialized views for frequently-run queries
8. Set up cost controls and quotas
