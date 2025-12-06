# Monitoring & Optimization

[![Monitoring](https://img.shields.io/badge/Cloud%20Monitoring-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/monitoring)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Monitoring & Optimization - Observe and Optimize Your Data Pipelines**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## Overview

Effective monitoring and optimization are critical for production data engineering systems. This module covers Cloud Monitoring, Logging, alerting, cost optimization, and performance tuning for BigQuery, Dataflow, and other GCP services.

---

## Cloud Monitoring

### Custom Metrics

```python
from google.cloud import monitoring_v3

client = monitoring_v3.MetricServiceClient()
project_name = f"projects/{project_id}"

# Create custom metric
descriptor = monitoring_v3.MetricDescriptor()
descriptor.type = "custom.googleapis.com/pipeline/records_processed"
descriptor.metric_kind = monitoring_v3.MetricDescriptor.MetricKind.GAUGE
descriptor.value_type = monitoring_v3.MetricDescriptor.ValueType.INT64
descriptor.description = "Records processed by pipeline"

client.create_metric_descriptor(name=project_name, metric_descriptor=descriptor)

# Write metric data
series = monitoring_v3.TimeSeries()
series.metric.type = "custom.googleapis.com/pipeline/records_processed"
series.resource.type = "global"

point = monitoring_v3.Point()
point.value.int64_value = 1000
point.interval.end_time.seconds = int(time.time())
series.points = [point]

client.create_time_series(name=project_name, time_series=[series])
```

### Alerting Policies

```bash
# Create alert for BigQuery slot usage
gcloud alpha monitoring policies create \
    --display-name="High Slot Usage" \
    --condition-display-name="Slot usage > 80%" \
    --condition-filter='resource.type="bigquery_project" AND metric.type="bigquery.googleapis.com/slots/allocated"' \
    --condition-threshold-value=80 \
    --condition-threshold-comparison=COMPARISON_GT \
    --notification-channels=CHANNEL_ID
```

---

## BigQuery Optimization

### Query Optimization

```sql
-- Use EXPLAIN to analyze query
EXPLAIN
SELECT * FROM `project.dataset.table` WHERE date = '2024-01-01';

-- Check slot usage
SELECT
    job_id,
    total_slot_ms / 1000 as slot_seconds,
    total_bytes_processed / 1e9 as gb_processed
FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)
ORDER BY total_slot_ms DESC
LIMIT 10;
```

### Cost Optimization

```sql
-- Estimate query cost before running
SELECT
    total_bytes_processed / 1e12 * 5 as estimated_cost_usd
FROM (
    SELECT total_bytes_processed
    FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
    WHERE job_id = 'your-job-id'
);
```

---

## Dataflow Monitoring

```python
# Monitor Dataflow job metrics
from google.cloud import monitoring_v3

client = monitoring_v3.MetricServiceClient()

# Query Dataflow metrics
interval = monitoring_v3.TimeInterval()
interval.end_time.seconds = int(time.time())
interval.start_time.seconds = int(time.time()) - 3600

results = client.list_time_series(
    request={
        "name": f"projects/{project_id}",
        "filter": 'metric.type="dataflow.googleapis.com/job/elements_produced_count"',
        "interval": interval,
    }
)
```

---

## Cost Management

### Budget Alerts

```bash
gcloud billing budgets create \
    --billing-account=BILLING_ACCOUNT_ID \
    --display-name="Data Platform Budget" \
    --budget-amount=10000USD \
    --threshold-rule=percent=50,basis=CURRENT_SPEND \
    --threshold-rule=percent=90,basis=CURRENT_SPEND \
    --threshold-rule=percent=100,basis=FORECASTED_SPEND
```

### BigQuery Reservations

```bash
# Create slot reservation for predictable costs
bq mk --reservation \
    --project_id=PROJECT_ID \
    --location=US \
    --slots=500 \
    my_reservation
```

---

## Interview Tips

**Q: How do you optimize BigQuery costs?**
> Use partitioning and clustering, avoid SELECT *, use BI Engine for dashboards, consider flat-rate pricing for predictable workloads, and implement query quotas.

**Q: How do you monitor Dataflow pipeline health?**
> Track system lag, data freshness, throughput, and error rates. Set up alerts for backlog growth and worker utilization. Use Cloud Monitoring dashboards for visualization.

---

## Next Steps

- [Cost Optimization](../cost-optimization/) - FinOps best practices
- [BigQuery Advanced](../bigquery-advanced/) - Query optimization
