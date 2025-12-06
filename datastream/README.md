# Datastream

[![Datastream](https://img.shields.io/badge/Datastream-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/datastream)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Datastream - Serverless Change Data Capture**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Datastream?

Datastream is a serverless change data capture (CDC) and replication service that allows you to synchronize data across heterogeneous databases and applications reliably with minimal latency. It supports MySQL, PostgreSQL, Oracle, and SQL Server as sources, with BigQuery and Cloud Storage as destinations.

---

## Key Features

- **Serverless**: No infrastructure to manage
- **Real-time CDC**: Sub-second latency
- **Schema Evolution**: Automatic schema changes
- **Backfill**: Historical data migration
- **Multiple Sources**: MySQL, PostgreSQL, Oracle, SQL Server

---

## Quick Start

```bash
# Create connection profile for source
gcloud datastream connection-profiles create mysql-source \
    --location=us-central1 \
    --type=mysql \
    --mysql-hostname=10.0.0.1 \
    --mysql-port=3306 \
    --mysql-username=replication_user \
    --mysql-password=password \
    --display-name="MySQL Source"

# Create connection profile for BigQuery destination
gcloud datastream connection-profiles create bq-dest \
    --location=us-central1 \
    --type=bigquery \
    --display-name="BigQuery Destination"

# Create stream
gcloud datastream streams create mysql-to-bq \
    --location=us-central1 \
    --source=mysql-source \
    --mysql-source-config='{"include_objects":{"mysql_databases":[{"database":"mydb"}]}}' \
    --destination=bq-dest \
    --bigquery-destination-config='{"data_freshness":"900s","single_target_dataset":{"dataset_id":"project:dataset"}}' \
    --backfill-all \
    --display-name="MySQL to BigQuery"
```

---

## CDC Architecture

```
Source DB → Binary Log → Datastream → BigQuery
    ↓           ↓            ↓           ↓
 Changes    Capture      Process     Merge
```

---

## BigQuery Destination

Datastream creates tables in BigQuery with additional metadata columns:

| Column | Description |
|--------|-------------|
| `datastream_metadata.uuid` | Unique event ID |
| `datastream_metadata.source_timestamp` | When change occurred |
| `datastream_metadata.is_deleted` | Soft delete flag |

---

## Interview Tips

**Q: When would you use Datastream vs Dataflow for CDC?**
> Datastream for simple, serverless CDC with automatic schema evolution. Dataflow when you need complex transformations, custom logic, or streaming joins during replication.

**Q: How does Datastream handle schema changes?**
> Datastream automatically detects schema changes (new columns, type changes) and applies them to the destination. It uses BigQuery's schema evolution capabilities.

---

## Next Steps

- [BigQuery](../bigquery-basics/) - Query replicated data
- [Dataflow](../dataflow-basics/) - Transform CDC streams
