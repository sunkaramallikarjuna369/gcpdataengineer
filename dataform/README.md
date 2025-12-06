# Dataform

[![Dataform](https://img.shields.io/badge/Dataform-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/dataform)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Dataform - SQL-Based Data Transformation in BigQuery**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Dataform?

Dataform is a service for data analysts to develop, test, version control, and schedule complex SQL workflows in BigQuery. It provides a development environment for writing SQLX (SQL with Jinja-like templating), managing dependencies, and implementing data quality tests.

---

## Key Features

- **SQLX**: SQL with templating and dependencies
- **Version Control**: Git-based workflow
- **Testing**: Built-in data quality assertions
- **Documentation**: Auto-generated docs
- **Scheduling**: Integrated with Cloud Scheduler

---

## Quick Start

### SQLX File Structure

```sql
-- definitions/staging/stg_orders.sqlx
config {
    type: "view",
    schema: "staging",
    description: "Staged orders data"
}

SELECT
    order_id,
    customer_id,
    PARSE_TIMESTAMP('%Y-%m-%d', order_date) as order_date,
    total_amount
FROM ${ref("raw_orders")}
WHERE order_id IS NOT NULL
```

### Incremental Tables

```sql
-- definitions/marts/fct_daily_sales.sqlx
config {
    type: "incremental",
    schema: "marts",
    uniqueKey: ["date", "product_id"],
    bigquery: {
        partitionBy: "date"
    }
}

SELECT
    DATE(order_date) as date,
    product_id,
    SUM(quantity) as total_quantity,
    SUM(amount) as total_amount
FROM ${ref("stg_orders")}
${when(incremental(), `WHERE order_date > (SELECT MAX(date) FROM ${self()})`)}
GROUP BY 1, 2
```

### Assertions

```sql
-- definitions/assertions/assert_orders_not_null.sqlx
config {
    type: "assertion"
}

SELECT *
FROM ${ref("stg_orders")}
WHERE order_id IS NULL
   OR customer_id IS NULL
```

---

## Project Structure

```
dataform/
├── definitions/
│   ├── sources/
│   │   └── raw_tables.sqlx
│   ├── staging/
│   │   └── stg_*.sqlx
│   ├── marts/
│   │   └── fct_*.sqlx
│   └── assertions/
│       └── assert_*.sqlx
├── includes/
│   └── helpers.js
└── dataform.json
```

---

## Interview Tips

**Q: How does Dataform compare to dbt?**
> Both are SQL-based transformation tools. Dataform is GCP-native, integrated with BigQuery, and uses SQLX. dbt is cloud-agnostic, has a larger community, and uses Jinja templating.

**Q: How do you implement incremental models in Dataform?**
> Use `type: "incremental"` config with a `uniqueKey`. Use the `incremental()` function to conditionally filter for new data. Dataform handles merge logic automatically.

---

## Next Steps

- [BigQuery Advanced](../bigquery-advanced/) - Complex SQL patterns
- [Data Quality](../data-quality/) - Testing strategies
