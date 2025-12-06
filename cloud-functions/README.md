# Cloud Functions

[![Cloud Functions](https://img.shields.io/badge/Cloud%20Functions-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/functions)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Cloud Functions - Serverless Event-Driven Computing**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Functions?

Cloud Functions is a serverless execution environment for building and connecting cloud services. Functions are triggered by events from GCP services (Pub/Sub, Cloud Storage, HTTP) and scale automatically from zero to handle load.

---

## Function Types

### HTTP Functions
```python
import functions_framework

@functions_framework.http
def hello_http(request):
    name = request.args.get('name', 'World')
    return f'Hello, {name}!'
```

### Event-Driven Functions
```python
import functions_framework
from google.cloud import bigquery

@functions_framework.cloud_event
def process_gcs_file(cloud_event):
    data = cloud_event.data
    bucket = data['bucket']
    name = data['name']
    
    # Load file to BigQuery
    client = bigquery.Client()
    uri = f'gs://{bucket}/{name}'
    
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        autodetect=True
    )
    
    load_job = client.load_table_from_uri(
        uri, 'project.dataset.table', job_config=job_config
    )
    load_job.result()
```

### Pub/Sub Trigger
```python
import base64
import functions_framework

@functions_framework.cloud_event
def process_pubsub(cloud_event):
    data = base64.b64decode(cloud_event.data['message']['data']).decode()
    print(f'Received message: {data}')
```

---

## Deployment

```bash
# Deploy HTTP function
gcloud functions deploy hello-http \
    --gen2 \
    --runtime=python311 \
    --region=us-central1 \
    --source=. \
    --entry-point=hello_http \
    --trigger-http \
    --allow-unauthenticated

# Deploy GCS trigger
gcloud functions deploy process-file \
    --gen2 \
    --runtime=python311 \
    --region=us-central1 \
    --source=. \
    --entry-point=process_gcs_file \
    --trigger-event-filters="type=google.cloud.storage.object.v1.finalized" \
    --trigger-event-filters="bucket=my-bucket"
```

---

## Interview Tips

**Q: When would you use Cloud Functions vs Cloud Run?**
> Cloud Functions for simple event-driven tasks, quick integrations, and when you want automatic scaling from zero. Cloud Run for containerized apps, longer-running processes, and when you need more control.

**Q: How do you handle cold starts in Cloud Functions?**
> Use minimum instances to keep functions warm, optimize dependencies, use lazy initialization, and consider Cloud Run for latency-sensitive workloads.

---

## Next Steps

- [Cloud Run](../cloud-run/) - Containerized serverless
- [Pub/Sub](../pubsub-messaging/) - Event triggers
