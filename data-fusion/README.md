# Cloud Data Fusion

[![Data Fusion](https://img.shields.io/badge/Data%20Fusion-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/data-fusion)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Cloud Data Fusion - Visual ETL Pipeline Builder**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Data Fusion?

Cloud Data Fusion is a fully managed, cloud-native data integration service that allows users to build and manage ETL/ELT pipelines using a visual interface. Built on CDAP (Cask Data Application Platform), it provides a code-free way to connect, transform, and move data.

---

## Key Features

- **Visual Pipeline Builder**: Drag-and-drop interface
- **150+ Connectors**: Pre-built source and sink plugins
- **Wrangler**: Interactive data preparation
- **Reusable Pipelines**: Templates and macros
- **Lineage**: Automatic data lineage tracking

---

## Pipeline Components

### Sources
- BigQuery, Cloud Storage, Cloud SQL
- MySQL, PostgreSQL, Oracle, SQL Server
- Salesforce, SAP, ServiceNow
- Kafka, Pub/Sub

### Transforms
- Wrangler (data cleaning)
- JavaScript, Python
- Joiner, Group By, Deduplicate
- Normalizer, Pivot

### Sinks
- BigQuery, Cloud Storage
- Cloud SQL, Spanner
- Pub/Sub, Bigtable

---

## Quick Start

```bash
# Create Data Fusion instance
gcloud data-fusion instances create my-instance \
    --location=us-central1 \
    --type=BASIC \
    --enable-stackdriver-logging \
    --enable-stackdriver-monitoring

# Get instance details
gcloud data-fusion instances describe my-instance \
    --location=us-central1
```

---

## Pipeline JSON Example

```json
{
  "name": "GCS-to-BigQuery",
  "description": "Load CSV from GCS to BigQuery",
  "artifact": {
    "name": "cdap-data-pipeline",
    "version": "6.7.0",
    "scope": "SYSTEM"
  },
  "config": {
    "stages": [
      {
        "name": "GCS",
        "plugin": {
          "name": "GCSFile",
          "type": "batchsource",
          "properties": {
            "path": "gs://bucket/data.csv",
            "format": "csv"
          }
        }
      },
      {
        "name": "BigQuery",
        "plugin": {
          "name": "BigQueryTable",
          "type": "batchsink",
          "properties": {
            "dataset": "my_dataset",
            "table": "my_table"
          }
        }
      }
    ],
    "connections": [
      {"from": "GCS", "to": "BigQuery"}
    ]
  }
}
```

---

## Interview Tips

**Q: When would you use Data Fusion vs Dataflow?**
> Data Fusion for visual, code-free ETL by analysts, quick prototyping, and when using pre-built connectors. Dataflow for complex transformations, streaming, and when you need custom code.

**Q: How does Data Fusion handle large-scale data?**
> Data Fusion compiles pipelines to run on Dataproc (Spark) for batch or Dataflow for real-time. The visual interface is for design; execution leverages GCP's scalable compute.

---

## Next Steps

- [Dataflow](../dataflow-basics/) - Code-based ETL
- [Dataprep](../dataprep/) - Data preparation
