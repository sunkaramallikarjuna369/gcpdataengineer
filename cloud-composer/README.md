# Cloud Composer

[![Cloud Composer](https://img.shields.io/badge/Cloud%20Composer-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/composer)
[![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=apache-airflow&logoColor=white)](https://airflow.apache.org/)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Cloud Composer - Managed Apache Airflow for Workflow Orchestration**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Composer?

Cloud Composer is a fully managed workflow orchestration service built on Apache Airflow. It allows you to author, schedule, and monitor data pipelines that span across clouds and on-premises data centers. Composer handles the infrastructure, scaling, and maintenance of Airflow, letting you focus on building workflows.

Workflows in Composer are defined as Directed Acyclic Graphs (DAGs) using Python. Each DAG consists of tasks that can run operators for various services - BigQuery queries, Dataflow jobs, Cloud Functions, and hundreds of other integrations. The service provides a web UI for monitoring, alerting, and debugging your pipelines.

Composer integrates deeply with GCP services and supports hybrid/multi-cloud scenarios. It's the go-to solution for orchestrating complex data engineering workflows that involve multiple systems and dependencies.

---

## Why Use Cloud Composer?

**Business Value:**
- **Managed Service**: No Airflow infrastructure to maintain
- **Reliability**: Built-in HA, automatic recovery
- **Visibility**: Web UI for monitoring and debugging
- **Flexibility**: Python-based DAGs, extensive operator library
- **Integration**: Native GCP connectors, cross-cloud support

**Technical Advantages:**
- Apache Airflow's mature ecosystem
- Dynamic DAG generation
- Task dependencies and retries
- SLA monitoring and alerting
- Secrets management integration

---

## When to Use Cloud Composer?

**Ideal Use Cases:**
- Orchestrating ETL/ELT pipelines
- Scheduling BigQuery jobs
- Coordinating Dataflow pipelines
- ML training workflow automation
- Cross-service data workflows
- Batch processing schedules

**Not Ideal For:**
- Real-time event processing (use Pub/Sub + Dataflow)
- Simple scheduled tasks (use Cloud Scheduler)
- Sub-minute scheduling requirements
- Very small workloads (cost overhead)

---

## How It Works

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                   Cloud Composer Architecture                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Composer Environment                   │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │    │
│  │  │  Airflow    │  │  Airflow    │  │   Cloud     │      │    │
│  │  │  Webserver  │  │  Scheduler  │  │   SQL       │      │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘      │    │
│  │                                                           │    │
│  │  ┌─────────────────────────────────────────────────┐    │    │
│  │  │              GKE Worker Nodes                     │    │    │
│  │  │  ┌─────────┐  ┌─────────┐  ┌─────────┐          │    │    │
│  │  │  │ Worker  │  │ Worker  │  │ Worker  │          │    │    │
│  │  │  └─────────┘  └─────────┘  └─────────┘          │    │    │
│  │  └─────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                   │
│  ┌─────────────┐                      ┌─────────────┐            │
│  │    GCS      │◀────── DAGs ────────▶│  Airflow    │            │
│  │   Bucket    │                      │    UI       │            │
│  └─────────────┘                      └─────────────┘            │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Key Concepts

1. **DAG**: Directed Acyclic Graph defining workflow
2. **Task**: Single unit of work in a DAG
3. **Operator**: Template for a task (BigQueryOperator, etc.)
4. **Sensor**: Waits for external condition
5. **Hook**: Interface to external systems
6. **XCom**: Cross-task communication

### Quick Start DAG

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'email_on_failure': True,
    'email': ['team@company.com'],
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'daily_etl_pipeline',
    default_args=default_args,
    description='Daily ETL from GCS to BigQuery',
    schedule_interval='0 6 * * *',  # 6 AM daily
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['etl', 'bigquery'],
) as dag:

    def extract_data(**context):
        print(f"Extracting data for {context['ds']}")
        return "extracted"

    extract = PythonOperator(
        task_id='extract_data',
        python_callable=extract_data,
    )

    transform = BigQueryInsertJobOperator(
        task_id='transform_data',
        configuration={
            'query': {
                'query': '''
                    SELECT * FROM `project.dataset.source`
                    WHERE date = '{{ ds }}'
                ''',
                'destinationTable': {
                    'projectId': 'project',
                    'datasetId': 'dataset',
                    'tableId': 'target'
                },
                'writeDisposition': 'WRITE_APPEND',
            }
        },
    )

    def validate_data(**context):
        print("Validating data quality")
        return True

    validate = PythonOperator(
        task_id='validate_data',
        python_callable=validate_data,
    )

    extract >> transform >> validate
```

---

## Prerequisites Setup

```bash
# Enable APIs
gcloud services enable composer.googleapis.com
gcloud services enable container.googleapis.com

# Create Composer environment
gcloud composer environments create my-composer-env \
    --location=us-central1 \
    --image-version=composer-2.5.0-airflow-2.6.3

# Get DAGs bucket
gcloud composer environments describe my-composer-env \
    --location=us-central1 \
    --format="value(config.dagGcsPrefix)"

# Upload DAG
gsutil cp my_dag.py gs://your-composer-bucket/dags/
```

---

## Hands-On Labs

| Lab | Description | Time |
|-----|-------------|------|
| [Lab 1](./python-labs/01-first-dag.ipynb) | Create your first DAG | 30 min |
| [Lab 2](./python-labs/02-gcp-operators.ipynb) | BigQuery and GCS operators | 45 min |
| [Lab 3](./python-labs/03-advanced-patterns.ipynb) | Branching, sensors, XCom | 60 min |

---

## Sample DAGs

Check out the [dags/](./dags/) folder for production-ready examples:
- `etl_gcs_to_bigquery.py` - Standard ETL pattern
- `dataflow_orchestration.py` - Running Dataflow jobs
- `ml_training_pipeline.py` - ML workflow automation

---

## Interview Tips

**Q: How do you handle task dependencies in Airflow?**
> Use the `>>` and `<<` operators or `set_upstream()`/`set_downstream()`. For complex dependencies, use task groups and dynamic task mapping.

**Q: What's the difference between schedule_interval and timetable?**
> `schedule_interval` uses cron expressions or timedelta. Timetables (Airflow 2.2+) provide more flexibility for complex schedules like business days only.

**Q: How do you pass data between tasks?**
> Use XCom for small data (<48KB). For larger data, write to GCS/BigQuery and pass the reference via XCom.

---

## Teardown

```bash
gcloud composer environments delete my-composer-env --location=us-central1
```

---

## Next Steps

- [Dataflow Basics](../dataflow-basics/) - Orchestrate Dataflow jobs
- [BigQuery Advanced](../bigquery-advanced/) - Complex BigQuery workflows
