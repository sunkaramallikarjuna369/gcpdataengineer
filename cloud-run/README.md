# Cloud Run

[![Cloud Run](https://img.shields.io/badge/Cloud%20Run-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/run)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Cloud Run - Serverless Containers**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Run?

Cloud Run is a fully managed compute platform that lets you run containers directly on Google's scalable infrastructure. It automatically scales your containerized applications from zero to thousands of instances based on incoming requests.

---

## Key Features

- **Any Language**: Run any container
- **Scale to Zero**: Pay only when running
- **HTTPS by Default**: Automatic TLS
- **Custom Domains**: Easy domain mapping
- **Concurrency**: Handle multiple requests per instance

---

## Quick Start

```dockerfile
# Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
```

```bash
# Build and deploy
gcloud builds submit --tag gcr.io/PROJECT_ID/my-app
gcloud run deploy my-app \
    --image gcr.io/PROJECT_ID/my-app \
    --platform managed \
    --region us-central1 \
    --allow-unauthenticated
```

---

## Data Engineering Use Cases

### API for ML Model Serving
```python
from flask import Flask, request, jsonify
from google.cloud import bigquery

app = Flask(__name__)
client = bigquery.Client()

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    query = f"""
        SELECT * FROM ML.PREDICT(
            MODEL `project.dataset.model`,
            (SELECT {data['features']} AS features)
        )
    """
    result = client.query(query).result()
    return jsonify([dict(row) for row in result])
```

### Webhook for Data Ingestion
```python
@app.route('/webhook', methods=['POST'])
def webhook():
    data = request.json
    # Write to BigQuery
    errors = client.insert_rows_json('project.dataset.table', [data])
    return jsonify({'status': 'ok' if not errors else 'error'})
```

---

## Interview Tips

**Q: When would you use Cloud Run vs GKE?**
> Cloud Run for stateless HTTP workloads, quick deployments, and when you want managed infrastructure. GKE for complex orchestration, stateful workloads, and when you need full Kubernetes features.

**Q: How do you handle long-running tasks in Cloud Run?**
> Use Cloud Tasks for async processing, increase timeout (up to 60 min), or use Cloud Run jobs for batch workloads.

---

## Next Steps

- [Cloud Functions](../cloud-functions/) - Simpler serverless
- [Vertex AI](../vertex-ai/) - Model serving
