# Dataproc

[![Dataproc](https://img.shields.io/badge/Dataproc-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/dataproc)
[![Apache Spark](https://img.shields.io/badge/Apache%20Spark-E25A1C?style=for-the-badge&logo=apache-spark&logoColor=white)](https://spark.apache.org/)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Dataproc - Managed Spark and Hadoop Clusters**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Dataproc?

Dataproc is a fully managed service for running Apache Spark, Hadoop, Hive, and Pig workloads. It provides fast cluster creation (90 seconds), autoscaling, and integration with other GCP services. Dataproc is ideal for batch processing, ETL, and machine learning workloads that require the Spark/Hadoop ecosystem.

---

## Why Use Dataproc?

- **Fast Provisioning**: Clusters ready in ~90 seconds
- **Cost Effective**: Per-second billing, preemptible VMs
- **Autoscaling**: Scale based on workload
- **Ecosystem**: Full Spark/Hadoop/Hive/Pig support
- **Integration**: Native GCS, BigQuery connectors
- **Serverless**: Dataproc Serverless for Spark

---

## Quick Start

```bash
# Create a cluster
gcloud dataproc clusters create my-cluster \
    --region=us-central1 \
    --num-workers=2 \
    --worker-machine-type=n1-standard-4 \
    --image-version=2.1-debian11

# Submit a Spark job
gcloud dataproc jobs submit spark \
    --cluster=my-cluster \
    --region=us-central1 \
    --class=org.apache.spark.examples.SparkPi \
    --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
    -- 1000

# Submit a PySpark job
gcloud dataproc jobs submit pyspark \
    --cluster=my-cluster \
    --region=us-central1 \
    gs://your-bucket/scripts/my_job.py
```

---

## PySpark Example

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("GCS to BigQuery").getOrCreate()

# Read from GCS
df = spark.read.parquet("gs://bucket/data/*.parquet")

# Transform
result = df.groupBy("category").agg({"amount": "sum"})

# Write to BigQuery
result.write.format("bigquery") \
    .option("table", "project.dataset.table") \
    .mode("overwrite") \
    .save()
```

---

## Dataproc Serverless

```bash
# Submit serverless Spark batch
gcloud dataproc batches submit spark \
    --region=us-central1 \
    --jars=gs://bucket/jars/my-job.jar \
    --class=com.example.MyJob \
    -- arg1 arg2
```

---

## Interview Tips

**Q: When would you use Dataproc vs Dataflow?**
> Dataproc for existing Spark/Hadoop workloads, complex ML with Spark MLlib, or when you need the Hadoop ecosystem. Dataflow for new pipelines, unified batch/stream, and when you want fully serverless.

**Q: How do you optimize Dataproc costs?**
> Use preemptible VMs for workers, enable autoscaling, use Dataproc Serverless for sporadic workloads, and delete clusters when not in use.

---

## Next Steps

- [Dataflow Basics](../dataflow-basics/) - Alternative for ETL
- [BigQuery](../bigquery-basics/) - Data warehouse destination
