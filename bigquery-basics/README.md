# BigQuery Basics

[![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Difficulty: Beginner](https://img.shields.io/badge/Difficulty-Beginner-green?style=for-the-badge)](.)
[![Time: 4 hours](https://img.shields.io/badge/Time-4%20hours-blue?style=for-the-badge)](.)

> **Master Google BigQuery - The Serverless Data Warehouse**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is BigQuery?

BigQuery is Google Cloud's fully managed, serverless, highly scalable, and cost-effective multi-cloud data warehouse designed for business agility. It enables super-fast SQL queries using the processing power of Google's infrastructure, allowing you to analyze petabytes of data in seconds without managing any infrastructure.

At its core, BigQuery separates storage and compute, meaning you pay only for what you use. Data is stored in Capacitor columnar format, which provides excellent compression and enables efficient analytical queries. The Dremel execution engine powers BigQuery's ability to scan billions of rows in seconds by distributing queries across thousands of workers.

BigQuery supports standard SQL (SQL:2011 compliant), making it accessible to anyone familiar with SQL. It integrates seamlessly with other GCP services like Cloud Storage, Dataflow, Pub/Sub, and Vertex AI, forming the backbone of most GCP data architectures.

---

## Why Use BigQuery?

**Business Value:**
- **Zero Infrastructure Management**: No servers to provision, no indexes to maintain, no partitions to manage manually
- **Petabyte Scale**: Analyze massive datasets that would be impossible with traditional databases
- **Real-time Analytics**: Stream data directly into BigQuery for near real-time insights
- **Cost Efficiency**: Pay only for queries run and data stored; first 1TB/month of queries is free
- **Built-in ML**: Train and deploy machine learning models using SQL with BigQuery ML

**Technical Advantages:**
- Columnar storage optimized for analytical workloads
- Automatic data replication across multiple zones
- Built-in caching for repeated queries
- Federated queries to external data sources
- Native integration with BI tools (Looker, Data Studio, Tableau)

---

## When to Use BigQuery?

**Ideal Use Cases:**
- Data warehousing and business intelligence
- Log and event analytics
- Real-time analytics dashboards
- Machine learning feature engineering
- Ad-hoc data exploration
- ETL/ELT data transformations

**Not Ideal For:**
- OLTP workloads (use Cloud SQL or Spanner instead)
- Low-latency (<100ms) queries (use Bigtable)
- Small datasets (<1GB) with simple queries
- Transactional updates to individual rows

---

## Who Should Learn This?

- **Data Engineers**: Building data pipelines and warehouses
- **Data Analysts**: Running complex analytical queries
- **Data Scientists**: Feature engineering and ML workflows
- **BI Developers**: Creating dashboards and reports
- **Cloud Architects**: Designing data platforms

**Prerequisites:**
- Basic SQL knowledge
- GCP account (free tier works)
- Understanding of data warehouse concepts (helpful but not required)

---

## How It Works

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        BigQuery Architecture                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐          │
│  │   Client    │───▶│  BigQuery   │───▶│   Dremel    │          │
│  │  (Console/  │    │    API      │    │  Execution  │          │
│  │   SDK/CLI)  │    │             │    │   Engine    │          │
│  └─────────────┘    └─────────────┘    └──────┬──────┘          │
│                                                │                  │
│                                                ▼                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Colossus Storage                       │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │    │
│  │  │ Table 1 │  │ Table 2 │  │ Table 3 │  │ Table N │     │    │
│  │  │(Column) │  │(Column) │  │(Column) │  │(Column) │     │    │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘     │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Key Concepts

1. **Projects**: Top-level container for GCP resources
2. **Datasets**: Containers for tables (like schemas in traditional DBs)
3. **Tables**: Store data in columnar format
4. **Views**: Virtual tables defined by SQL queries
5. **Jobs**: Actions like queries, loads, exports, copies

### Quick Start

```bash
# 1. Enable BigQuery API
gcloud services enable bigquery.googleapis.com

# 2. Create a dataset
bq mk --dataset --location=US my_project:my_dataset

# 3. Create a table from CSV
bq load --autodetect my_dataset.my_table gs://bucket/data.csv

# 4. Run a query
bq query --use_legacy_sql=false 'SELECT * FROM my_dataset.my_table LIMIT 10'
```

### Python Quick Start

```python
from google.cloud import bigquery

# Initialize client
client = bigquery.Client()

# Run a query
query = """
    SELECT name, COUNT(*) as count
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    GROUP BY name
    ORDER BY count DESC
    LIMIT 10
"""
results = client.query(query).result()

for row in results:
    print(f"{row.name}: {row.count}")
```

---

## Prerequisites Setup

### 1. GCP Project Setup

```bash
# Create a new project (or use existing)
gcloud projects create gcp-data-eng-labs --name="GCP Data Engineering Labs"

# Set as default project
gcloud config set project gcp-data-eng-labs

# Enable billing (required for BigQuery)
# Visit: https://console.cloud.google.com/billing

# Enable BigQuery API
gcloud services enable bigquery.googleapis.com
```

### 2. Authentication

```bash
# For local development
gcloud auth application-default login

# For service accounts (production)
gcloud iam service-accounts create bigquery-lab \
    --display-name="BigQuery Lab Service Account"

gcloud projects add-iam-policy-binding gcp-data-eng-labs \
    --member="serviceAccount:bigquery-lab@gcp-data-eng-labs.iam.gserviceaccount.com" \
    --role="roles/bigquery.admin"
```

### 3. Install Dependencies

```bash
pip install google-cloud-bigquery pandas pyarrow db-dtypes
```

---

## Hands-On Labs

| Lab | Description | Time |
|-----|-------------|------|
| [Python Lab 1](./python-labs/01-getting-started.ipynb) | BigQuery basics with Python SDK | 30 min |
| [Python Lab 2](./python-labs/02-data-loading.ipynb) | Loading data into BigQuery | 45 min |
| [Python Lab 3](./python-labs/03-querying-data.ipynb) | Advanced querying techniques | 45 min |
| [SQL Lab 1](./sql-labs/01-basic-queries.sql) | Basic SELECT, WHERE, GROUP BY | 30 min |
| [SQL Lab 2](./sql-labs/02-joins-subqueries.sql) | JOINs and subqueries | 45 min |
| [SQL Lab 3](./sql-labs/03-window-functions.sql) | Window functions and CTEs | 45 min |

---

## Exercises

### Easy
- [Create your first dataset and table](./exercises/easy/01-create-dataset.md)
- [Load CSV data into BigQuery](./exercises/easy/02-load-csv.md)
- [Write basic SELECT queries](./exercises/easy/03-basic-select.md)

### Medium
- [Optimize query performance](./exercises/medium/01-query-optimization.md)
- [Work with nested and repeated fields](./exercises/medium/02-nested-fields.md)
- [Create scheduled queries](./exercises/medium/03-scheduled-queries.md)

### Hard
- [Design a star schema data warehouse](./exercises/hard/01-star-schema.md)
- [Implement slowly changing dimensions](./exercises/hard/02-scd-implementation.md)
- [Build a real-time dashboard pipeline](./exercises/hard/03-realtime-dashboard.md)

---

## Interview Tips

### Common Questions

**Q: What is the difference between BigQuery and traditional data warehouses?**
> BigQuery is serverless (no infrastructure to manage), separates storage and compute (pay for what you use), and scales automatically. Traditional warehouses require capacity planning, server management, and often have fixed costs.

**Q: How does BigQuery achieve fast query performance?**
> BigQuery uses columnar storage (Capacitor format), the Dremel execution engine for distributed processing, and automatic caching. It can scan petabytes by distributing work across thousands of workers.

**Q: When would you use partitioning vs clustering?**
> Use partitioning when you frequently filter by a single column (date is most common). Use clustering when you filter or aggregate by multiple columns. You can use both together for optimal performance.

**Q: How do you optimize BigQuery costs?**
> - Use partitioned and clustered tables
> - Avoid SELECT * (query only needed columns)
> - Use query caching
> - Set up cost controls and quotas
> - Consider flat-rate pricing for predictable workloads

### Resume Bullets

- Designed and implemented BigQuery data warehouse processing 10TB+ daily, reducing query costs by 60% through partitioning and clustering strategies
- Built automated ETL pipelines loading data from 15+ sources into BigQuery using Dataflow and Cloud Composer
- Optimized BigQuery queries achieving 10x performance improvement through proper schema design and query optimization

---

## Teardown

```bash
# Delete dataset and all tables
bq rm -r -f my_project:my_dataset

# Delete service account
gcloud iam service-accounts delete bigquery-lab@gcp-data-eng-labs.iam.gserviceaccount.com

# Disable API (optional)
gcloud services disable bigquery.googleapis.com
```

---

## Additional Resources

- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices-performance-overview)
- [BigQuery Public Datasets](https://cloud.google.com/bigquery/public-data)
- [BigQuery Pricing](https://cloud.google.com/bigquery/pricing)

---

## Next Steps

After completing this module, continue to:
- [BigQuery Advanced](../bigquery-advanced/) - Partitioning, Clustering, Slots
- [BigQuery ML](../bigquery-ml/) - Machine Learning in SQL
- [Dataflow Basics](../dataflow-basics/) - ETL Pipelines with Apache Beam
