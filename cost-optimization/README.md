# Cost Optimization (FinOps)

[![FinOps](https://img.shields.io/badge/FinOps-34A853?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/billing)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master GCP Cost Optimization - FinOps Best Practices**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## Overview

FinOps (Financial Operations) is the practice of bringing financial accountability to cloud spending. This module covers cost optimization strategies for GCP data engineering services including BigQuery, Dataflow, Dataproc, and storage.

---

## BigQuery Cost Optimization

### On-Demand vs Flat-Rate

| Model | Best For | Pricing |
|-------|----------|---------|
| On-Demand | Variable workloads, <$10K/month | $5/TB scanned |
| Flat-Rate | Predictable workloads, >$10K/month | $2,000/100 slots/month |

### Query Optimization

```sql
-- Use partitioning to reduce data scanned
SELECT * FROM `project.dataset.events`
WHERE DATE(timestamp) = '2024-01-15'  -- Partition pruning

-- Avoid SELECT *
SELECT user_id, event_type, timestamp
FROM `project.dataset.events`

-- Use approximate functions for large datasets
SELECT APPROX_COUNT_DISTINCT(user_id) as unique_users
FROM `project.dataset.events`
```

### Cost Controls

```bash
# Set project-level quota
bq update --max_bytes_billed 1000000000000 project_id

# Create custom quota
gcloud alpha services quota update \
    --consumer=projects/PROJECT_ID \
    --service=bigquery.googleapis.com \
    --metric=bigquery.googleapis.com/quota/query/usage \
    --value=1000000000000
```

---

## Dataflow Cost Optimization

- Use **Dataflow Prime** for automatic optimization
- Enable **autoscaling** with appropriate min/max workers
- Use **Streaming Engine** for streaming jobs
- Choose appropriate **machine types**
- Use **preemptible VMs** for batch jobs

```bash
# Use Dataflow Prime with autoscaling
gcloud dataflow jobs run my-job \
    --gcs-location=gs://dataflow-templates/... \
    --enable-streaming-engine \
    --experiments=enable_prime \
    --max-workers=10 \
    --autoscaling-algorithm=THROUGHPUT_BASED
```

---

## Storage Cost Optimization

### Lifecycle Policies

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {"age": 30}
      },
      {
        "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
        "condition": {"age": 90}
      },
      {
        "action": {"type": "Delete"},
        "condition": {"age": 365}
      }
    ]
  }
}
```

---

## Budget Alerts

```bash
gcloud billing budgets create \
    --billing-account=BILLING_ACCOUNT_ID \
    --display-name="Data Platform Budget" \
    --budget-amount=10000USD \
    --threshold-rule=percent=50 \
    --threshold-rule=percent=90 \
    --threshold-rule=percent=100
```

---

## Interview Tips

**Q: How do you optimize BigQuery costs?**
> Use partitioning/clustering, avoid SELECT *, use BI Engine for dashboards, consider flat-rate for predictable workloads, set query quotas, and use materialized views.

**Q: How do you implement FinOps in a data platform?**
> Establish cost visibility with billing exports to BigQuery, set budgets and alerts, implement chargebacks by team/project, optimize resource usage, and regularly review spending.

---

## Next Steps

- [Monitoring](../monitoring-optimization/) - Cost dashboards
- [BigQuery Advanced](../bigquery-advanced/) - Query optimization
