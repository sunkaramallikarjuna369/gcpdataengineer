# Vertex AI

[![Vertex AI](https://img.shields.io/badge/Vertex%20AI-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/vertex-ai)
[![Difficulty: Advanced](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)](.)

> **Master Vertex AI - Unified ML Platform for Building and Deploying Models**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Vertex AI?

Vertex AI is Google Cloud's unified machine learning platform that brings together all GCP ML services under one roof. It provides tools for the entire ML workflow: data preparation, model training, hyperparameter tuning, model deployment, and monitoring. Vertex AI supports both AutoML for no-code solutions and custom training for advanced use cases.

The platform integrates with BigQuery for feature engineering, supports popular frameworks like TensorFlow, PyTorch, and scikit-learn, and provides managed infrastructure for training and serving. Feature Store enables feature reuse across teams, while Pipelines orchestrates ML workflows.

---

## Why Use Vertex AI?

- **Unified Platform**: All ML tools in one place
- **AutoML**: Build models without coding
- **Custom Training**: Full control with any framework
- **Feature Store**: Centralized feature management
- **Model Registry**: Version and manage models
- **Managed Endpoints**: Scalable model serving

---

## Key Components

### AutoML
Train high-quality models with minimal ML expertise on tabular, image, text, and video data.

### Custom Training
Use pre-built containers or custom containers with TensorFlow, PyTorch, XGBoost, or scikit-learn.

### Feature Store
Centralized repository for storing, serving, and sharing ML features.

### Pipelines
Orchestrate ML workflows using Kubeflow Pipelines or TFX.

### Model Registry
Version, organize, and track models throughout their lifecycle.

### Endpoints
Deploy models for online or batch predictions with autoscaling.

---

## Quick Start

```python
from google.cloud import aiplatform

aiplatform.init(project='your-project', location='us-central1')

# Create a dataset
dataset = aiplatform.TabularDataset.create(
    display_name='my-dataset',
    bq_source='bq://project.dataset.table'
)

# Train with AutoML
job = aiplatform.AutoMLTabularTrainingJob(
    display_name='my-training-job',
    optimization_prediction_type='classification'
)

model = job.run(
    dataset=dataset,
    target_column='label',
    training_fraction_split=0.8,
    validation_fraction_split=0.1,
    test_fraction_split=0.1
)

# Deploy model
endpoint = model.deploy(
    machine_type='n1-standard-4',
    min_replica_count=1,
    max_replica_count=3
)

# Make predictions
predictions = endpoint.predict(instances=[{'feature1': 1, 'feature2': 'value'}])
```

---

## Interview Tips

**Q: When would you use AutoML vs Custom Training?**
> AutoML for quick prototyping, limited ML expertise, or standard use cases. Custom Training for complex architectures, specific frameworks, or when you need full control over the training process.

**Q: What is Feature Store and why is it important?**
> Feature Store is a centralized repository for ML features. It ensures consistency between training and serving, enables feature reuse across teams, and provides point-in-time correctness for training data.

---

## Next Steps

- [BigQuery ML](../bigquery-ml/) - ML directly in BigQuery
- [Dataflow](../dataflow-basics/) - Feature engineering pipelines
