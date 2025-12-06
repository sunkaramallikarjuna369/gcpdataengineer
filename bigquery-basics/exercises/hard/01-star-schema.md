# Exercise: Design a Star Schema Data Warehouse

## Difficulty: Hard
## Time: 60 minutes

## Objective
Design and implement a star schema data warehouse in BigQuery for an e-commerce company.

## Prerequisites
- Understanding of dimensional modeling
- Completed BigQuery basics and intermediate labs
- Familiarity with ETL concepts

## Scenario

You're designing a data warehouse for "TechMart", an e-commerce company. They need to analyze:
- Sales performance by product, time, and location
- Customer purchasing patterns
- Inventory turnover

## Part 1: Schema Design

Design a star schema with the following:

### Fact Table: `fact_sales`
| Column | Type | Description |
|--------|------|-------------|
| sale_id | INT64 | Primary key |
| date_key | INT64 | FK to dim_date |
| product_key | INT64 | FK to dim_product |
| customer_key | INT64 | FK to dim_customer |
| store_key | INT64 | FK to dim_store |
| quantity | INT64 | Units sold |
| unit_price | FLOAT64 | Price per unit |
| total_amount | FLOAT64 | Total sale amount |
| discount_amount | FLOAT64 | Discount applied |

### Dimension Tables

**dim_date:**
- date_key, full_date, year, quarter, month, month_name, week, day_of_week, day_name, is_weekend, is_holiday

**dim_product:**
- product_key, product_id, product_name, category, subcategory, brand, unit_cost

**dim_customer:**
- customer_key, customer_id, first_name, last_name, email, city, state, country, customer_segment

**dim_store:**
- store_key, store_id, store_name, city, state, country, region, store_type

## Part 2: Implementation

### Task 1: Create the Dataset and Tables

```sql
-- Create dataset
CREATE SCHEMA IF NOT EXISTS `your-project.ecommerce_dw`
OPTIONS(location='US');

-- Create dim_date
CREATE OR REPLACE TABLE `your-project.ecommerce_dw.dim_date` AS
SELECT
    FORMAT_DATE('%Y%m%d', d) AS date_key,
    d AS full_date,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(QUARTER FROM d) AS quarter,
    EXTRACT(MONTH FROM d) AS month,
    FORMAT_DATE('%B', d) AS month_name,
    EXTRACT(WEEK FROM d) AS week,
    EXTRACT(DAYOFWEEK FROM d) AS day_of_week,
    FORMAT_DATE('%A', d) AS day_name,
    CASE WHEN EXTRACT(DAYOFWEEK FROM d) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend,
    FALSE AS is_holiday  -- Would need holiday calendar
FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', '2025-12-31')) AS d;

-- Your task: Create the other dimension tables
-- dim_product, dim_customer, dim_store
```

### Task 2: Create the Fact Table with Partitioning and Clustering

```sql
-- Create partitioned and clustered fact table
CREATE OR REPLACE TABLE `your-project.ecommerce_dw.fact_sales`
(
    sale_id INT64,
    date_key INT64,
    product_key INT64,
    customer_key INT64,
    store_key INT64,
    quantity INT64,
    unit_price FLOAT64,
    total_amount FLOAT64,
    discount_amount FLOAT64,
    sale_date DATE
)
PARTITION BY sale_date
CLUSTER BY product_key, store_key;
```

### Task 3: Load Sample Data

```sql
-- Generate sample fact data
INSERT INTO `your-project.ecommerce_dw.fact_sales`
SELECT
    ROW_NUMBER() OVER() AS sale_id,
    CAST(FORMAT_DATE('%Y%m%d', DATE_ADD('2024-01-01', INTERVAL CAST(RAND() * 365 AS INT64) DAY)) AS INT64) AS date_key,
    CAST(RAND() * 100 + 1 AS INT64) AS product_key,
    CAST(RAND() * 1000 + 1 AS INT64) AS customer_key,
    CAST(RAND() * 50 + 1 AS INT64) AS store_key,
    CAST(RAND() * 10 + 1 AS INT64) AS quantity,
    ROUND(RAND() * 500 + 10, 2) AS unit_price,
    0.0 AS total_amount,  -- Will calculate
    ROUND(RAND() * 50, 2) AS discount_amount,
    DATE_ADD('2024-01-01', INTERVAL CAST(RAND() * 365 AS INT64) DAY) AS sale_date
FROM UNNEST(GENERATE_ARRAY(1, 100000));

-- Update total_amount
UPDATE `your-project.ecommerce_dw.fact_sales`
SET total_amount = (quantity * unit_price) - discount_amount
WHERE TRUE;
```

## Part 3: Analytical Queries

### Query 1: Monthly Sales Trend
```sql
-- Your task: Write a query to show monthly sales trend
-- Include: month, total_sales, total_orders, avg_order_value
```

### Query 2: Top Products by Category
```sql
-- Your task: Write a query to find top 5 products in each category
-- Use window functions
```

### Query 3: Customer Segmentation Analysis
```sql
-- Your task: Analyze sales by customer segment
-- Include: segment, customer_count, total_revenue, avg_revenue_per_customer
```

### Query 4: Store Performance Dashboard
```sql
-- Your task: Create a store performance summary
-- Include: store, region, total_sales, yoy_growth
```

## Part 4: Optimization

### Task: Optimize for Common Query Patterns

1. What partitioning strategy would you use? Why?
2. What clustering columns would you choose? Why?
3. How would you handle slowly changing dimensions?

## Solutions

<details>
<summary>Click to reveal solutions</summary>

### Query 1 Solution:
```sql
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT f.sale_id) AS total_orders,
    SUM(f.total_amount) AS total_sales,
    ROUND(SUM(f.total_amount) / COUNT(DISTINCT f.sale_id), 2) AS avg_order_value
FROM `your-project.ecommerce_dw.fact_sales` f
JOIN `your-project.ecommerce_dw.dim_date` d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;
```

### Query 2 Solution:
```sql
WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(f.total_amount) AS total_sales,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(f.total_amount) DESC) AS rank
    FROM `your-project.ecommerce_dw.fact_sales` f
    JOIN `your-project.ecommerce_dw.dim_product` p ON f.product_key = p.product_key
    GROUP BY p.category, p.product_name
)
SELECT * FROM product_sales WHERE rank <= 5;
```

</details>

## Interview Questions

**Q: What is a star schema and why is it used in data warehousing?**

A: A star schema is a dimensional modeling technique where a central fact table containing metrics is surrounded by dimension tables containing descriptive attributes. It's called "star" because the diagram resembles a star. Benefits include:
- Simplified queries (fewer joins)
- Better query performance
- Intuitive for business users
- Optimized for analytical workloads

**Q: How would you handle slowly changing dimensions in BigQuery?**

A: Common approaches:
- Type 1: Overwrite old values (simple but loses history)
- Type 2: Add new rows with effective dates (preserves history)
- Type 3: Add columns for previous values (limited history)
- In BigQuery, Type 2 is often implemented using MERGE statements and effective_date/end_date columns.
