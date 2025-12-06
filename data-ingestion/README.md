# Data Ingestion

[![GCP](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Data Ingestion - Getting Data into GCP**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## Overview

Data ingestion is the process of moving data from various sources into GCP for processing and analysis. GCP provides multiple services for different ingestion patterns: batch transfers, streaming, CDC, and API-based loading.

---

## Ingestion Methods

### 1. Storage Transfer Service
Scheduled transfers from AWS S3, Azure, HTTP sources, or other GCS buckets.

```bash
gcloud transfer jobs create \
    --source-agent-pool=projects/my-project/agentPools/my-pool \
    --destination=gs://destination-bucket \
    --schedule-starts=2024-01-01T00:00:00Z \
    --schedule-repeats-every=1d
```

### 2. BigQuery Data Transfer Service
Automated data movement from SaaS applications to BigQuery.

```bash
bq mk --transfer_config \
    --data_source=google_cloud_storage \
    --target_dataset=my_dataset \
    --display_name='GCS to BQ Transfer' \
    --params='{"data_path_template":"gs://bucket/data/*.csv","destination_table_name_template":"my_table","file_format":"CSV"}'
```

### 3. Pub/Sub for Streaming
Real-time event ingestion.

```python
from google.cloud import pubsub_v1

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path('project', 'topic')

for event in events:
    data = json.dumps(event).encode('utf-8')
    publisher.publish(topic_path, data)
```

### 4. Datastream for CDC
Change Data Capture from MySQL, PostgreSQL, Oracle to BigQuery/GCS.

```bash
gcloud datastream streams create my-stream \
    --location=us-central1 \
    --source=my-source \
    --destination=my-destination \
    --backfill-all
```

---

## Choosing the Right Method

| Method | Use Case | Latency | Volume |
|--------|----------|---------|--------|
| Storage Transfer | Cloud-to-cloud migration | Hours | TB+ |
| BQ Data Transfer | SaaS to BigQuery | Hours | GB-TB |
| Pub/Sub | Real-time events | Seconds | Any |
| Datastream | Database CDC | Minutes | GB-TB |
| gsutil/bq load | Ad-hoc uploads | Minutes | GB |

---

## Interview Tips

**Q: How do you choose between batch and streaming ingestion?**
> Batch for historical data, scheduled loads, and when latency isn't critical. Streaming for real-time analytics, event-driven architectures, and when data freshness is important.

**Q: How do you handle schema evolution during ingestion?**
> Use schema auto-detection with caution, implement schema validation, use schema registries for streaming, and design for backward compatibility.

---

## Next Steps

- [Pub/Sub](../pubsub-messaging/) - Streaming ingestion
- [Dataflow](../dataflow-basics/) - Transform during ingestion
- [BigQuery](../bigquery-basics/) - Load data into warehouse
