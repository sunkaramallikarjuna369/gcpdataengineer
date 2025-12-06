# Dataflow Basics

[![Dataflow](https://img.shields.io/badge/Dataflow-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/dataflow)
[![Apache Beam](https://img.shields.io/badge/Apache%20Beam-FF6F00?style=for-the-badge&logo=apache&logoColor=white)](https://beam.apache.org/)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Google Cloud Dataflow - Unified Batch and Stream Processing**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Dataflow?

Google Cloud Dataflow is a fully managed service for executing Apache Beam pipelines for batch and streaming data processing. It provides a unified programming model that allows you to write your data processing logic once and run it on both bounded (batch) and unbounded (streaming) data sources without changing your code.

Dataflow automatically handles resource provisioning, worker scaling, and optimization. It uses the Apache Beam SDK, which provides a portable programming model that can run on multiple execution engines. When you deploy a Beam pipeline to Dataflow, it handles all the infrastructure complexity, allowing you to focus on your data transformation logic.

The service excels at ETL (Extract, Transform, Load) operations, real-time analytics, log processing, and machine learning data preparation. It integrates seamlessly with other GCP services like BigQuery, Pub/Sub, Cloud Storage, and Bigtable.

---

## Why Use Dataflow?

**Business Value:**
- **Unified Batch & Stream**: Same code for both batch and real-time processing
- **Fully Managed**: No cluster management, automatic scaling
- **Cost Efficient**: Pay only for resources used, with autoscaling
- **High Reliability**: Built-in fault tolerance and exactly-once processing
- **Ecosystem Integration**: Native connectors to GCP and external systems

**Technical Advantages:**
- Apache Beam's portable programming model
- Automatic optimization (fusion, combiner lifting)
- Dynamic work rebalancing
- Streaming with event-time processing
- Flexible windowing and triggering

---

## When to Use Dataflow?

**Ideal Use Cases:**
- ETL pipelines from various sources to BigQuery
- Real-time event processing from Pub/Sub
- Log and clickstream analytics
- Data enrichment and transformation
- Machine learning feature engineering
- CDC (Change Data Capture) processing

**Not Ideal For:**
- Simple scheduled SQL transformations (use BigQuery scheduled queries)
- Sub-second latency requirements (consider Bigtable or Memorystore)
- Small datasets with simple transformations
- Interactive/ad-hoc analysis (use BigQuery)

---

## Who Should Learn This?

- **Data Engineers**: Building production data pipelines
- **ML Engineers**: Preparing training data at scale
- **Analytics Engineers**: Creating data transformation workflows
- **Platform Engineers**: Building data infrastructure

**Prerequisites:**
- Python programming experience
- Basic understanding of distributed systems
- Familiarity with SQL and data transformations
- GCP fundamentals (Cloud Storage, BigQuery)

---

## How It Works

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Dataflow Architecture                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐          │
│  │   Sources   │───▶│   Dataflow  │───▶│    Sinks    │          │
│  │  (Pub/Sub,  │    │   Pipeline  │    │  (BigQuery, │          │
│  │   GCS, etc) │    │             │    │   GCS, etc) │          │
│  └─────────────┘    └──────┬──────┘    └─────────────┘          │
│                            │                                      │
│                            ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Worker Pool                            │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │    │
│  │  │ Worker  │  │ Worker  │  │ Worker  │  │ Worker  │     │    │
│  │  │   1     │  │   2     │  │   3     │  │   N     │     │    │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘     │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Key Concepts

1. **Pipeline**: The entire data processing workflow
2. **PCollection**: Distributed dataset (bounded or unbounded)
3. **PTransform**: Data transformation operation
4. **ParDo**: Parallel processing function
5. **Window**: Grouping mechanism for streaming data
6. **Trigger**: When to emit results for a window

### Quick Start

```bash
# 1. Install Apache Beam with GCP support
pip install apache-beam[gcp]

# 2. Set up authentication
gcloud auth application-default login

# 3. Run a simple pipeline locally
python -m apache_beam.examples.wordcount \
    --input gs://dataflow-samples/shakespeare/kinglear.txt \
    --output /tmp/output.txt

# 4. Run on Dataflow
python my_pipeline.py \
    --runner DataflowRunner \
    --project your-project-id \
    --region us-central1 \
    --temp_location gs://your-bucket/temp
```

### Python Quick Start

```python
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

# Define pipeline options
options = PipelineOptions([
    '--runner=DirectRunner',  # Use DataflowRunner for cloud
    '--project=your-project-id',
])

# Create and run pipeline
with beam.Pipeline(options=options) as p:
    (p
     | 'Read' >> beam.io.ReadFromText('input.txt')
     | 'Transform' >> beam.Map(lambda x: x.upper())
     | 'Write' >> beam.io.WriteToText('output.txt')
    )
```

---

## Prerequisites Setup

### 1. Enable APIs

```bash
gcloud services enable dataflow.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable storage.googleapis.com
```

### 2. Create Service Account

```bash
gcloud iam service-accounts create dataflow-sa \
    --display-name="Dataflow Service Account"

# Grant necessary roles
gcloud projects add-iam-policy-binding your-project-id \
    --member="serviceAccount:dataflow-sa@your-project-id.iam.gserviceaccount.com" \
    --role="roles/dataflow.worker"

gcloud projects add-iam-policy-binding your-project-id \
    --member="serviceAccount:dataflow-sa@your-project-id.iam.gserviceaccount.com" \
    --role="roles/storage.objectAdmin"
```

### 3. Create GCS Bucket

```bash
gsutil mb -l us-central1 gs://your-dataflow-bucket
```

---

## Hands-On Labs

| Lab | Description | Time |
|-----|-------------|------|
| [Python Lab 1](./python-labs/01-first-pipeline.ipynb) | Your first Beam pipeline | 30 min |
| [Python Lab 2](./python-labs/02-transforms.ipynb) | Core transforms (Map, Filter, GroupBy) | 45 min |
| [Python Lab 3](./python-labs/03-io-connectors.ipynb) | Reading/writing to GCS and BigQuery | 45 min |
| [Python Lab 4](./python-labs/04-streaming.ipynb) | Streaming pipelines with Pub/Sub | 60 min |

---

## Interview Tips

### Common Questions

**Q: What is the difference between batch and streaming in Dataflow?**
> Batch processes bounded data (finite), while streaming processes unbounded data (infinite). Dataflow uses the same Beam model for both, but streaming requires windowing and triggers to group and emit results.

**Q: How does Dataflow handle failures?**
> Dataflow provides exactly-once processing semantics. It checkpoints progress and can retry failed work. For streaming, it uses watermarks to track event-time progress and handle late data.

**Q: What is a watermark in streaming?**
> A watermark is Dataflow's notion of when all data up to a certain event time has arrived. It's used to determine when windows can be closed and results emitted.

### Resume Bullets

- Built real-time ETL pipeline processing 1M+ events/second using Dataflow and Pub/Sub, reducing data latency from hours to seconds
- Designed batch processing system migrating 50TB daily from legacy systems to BigQuery using Dataflow templates
- Optimized Dataflow pipelines achieving 40% cost reduction through proper windowing and autoscaling configuration

---

## Teardown

```bash
# Cancel running jobs
gcloud dataflow jobs cancel JOB_ID --region=us-central1

# Delete GCS bucket
gsutil rm -r gs://your-dataflow-bucket

# Delete service account
gcloud iam service-accounts delete dataflow-sa@your-project-id.iam.gserviceaccount.com
```

---

## Next Steps

- [Dataflow Streaming](../dataflow-streaming/) - Advanced streaming patterns
- [Pub/Sub Messaging](../pubsub-messaging/) - Event ingestion
- [Cloud Composer](../cloud-composer/) - Orchestrating Dataflow jobs
