# BigQuery Advanced

[![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Difficulty: Advanced](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)](.)

> **Master Advanced BigQuery - Optimization, Scripting, and Enterprise Patterns**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## Advanced Query Patterns

### Recursive CTEs

```sql
WITH RECURSIVE org_hierarchy AS (
    SELECT employee_id, manager_id, name, 1 as level
    FROM employees WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.employee_id, e.manager_id, e.name, h.level + 1
    FROM employees e
    JOIN org_hierarchy h ON e.manager_id = h.employee_id
)
SELECT * FROM org_hierarchy ORDER BY level;
```

### PIVOT and UNPIVOT

```sql
-- PIVOT: Rows to columns
SELECT * FROM (
    SELECT product, quarter, revenue
    FROM sales
)
PIVOT (SUM(revenue) FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4'));

-- UNPIVOT: Columns to rows
SELECT * FROM sales_wide
UNPIVOT (revenue FOR quarter IN (Q1, Q2, Q3, Q4));
```

### JavaScript UDFs

```sql
CREATE TEMP FUNCTION parseJSON(json_str STRING)
RETURNS STRUCT<name STRING, value FLOAT64>
LANGUAGE js AS """
    const obj = JSON.parse(json_str);
    return {name: obj.name, value: parseFloat(obj.value)};
""";

SELECT parseJSON('{"name": "test", "value": "123.45"}');
```

---

## BigQuery Scripting

```sql
DECLARE total_rows INT64;
DECLARE batch_size INT64 DEFAULT 10000;

SET total_rows = (SELECT COUNT(*) FROM source_table);

WHILE total_rows > 0 DO
    INSERT INTO target_table
    SELECT * FROM source_table
    LIMIT batch_size;
    
    DELETE FROM source_table
    WHERE id IN (SELECT id FROM target_table LIMIT batch_size);
    
    SET total_rows = total_rows - batch_size;
END WHILE;
```

---

## Optimization Techniques

### Partitioning Strategies

```sql
-- Time-based partitioning
CREATE TABLE events
PARTITION BY DATE(event_timestamp)
CLUSTER BY user_id, event_type
AS SELECT * FROM raw_events;

-- Integer range partitioning
CREATE TABLE customers
PARTITION BY RANGE_BUCKET(customer_id, GENERATE_ARRAY(0, 1000000, 10000))
AS SELECT * FROM raw_customers;
```

### Materialized Views

```sql
CREATE MATERIALIZED VIEW daily_stats
PARTITION BY date
CLUSTER BY region
AS
SELECT
    DATE(timestamp) as date,
    region,
    COUNT(*) as event_count,
    SUM(revenue) as total_revenue
FROM events
GROUP BY 1, 2;
```

---

## Interview Tips

**Q: How do you optimize a slow BigQuery query?**
> Check execution plan with EXPLAIN, use partitioning/clustering, avoid SELECT *, filter early, use approximate functions for large datasets, and consider materialized views.

**Q: What's the difference between partitioning and clustering?**
> Partitioning divides table into segments (reduces data scanned), clustering sorts data within partitions (improves filter/join performance). Use partitioning for date filters, clustering for high-cardinality columns.

---

## Next Steps

- [BigQuery ML](../bigquery-ml/) - Machine learning in SQL
- [BigQuery GIS](../bigquery-gis/) - Geospatial analytics
