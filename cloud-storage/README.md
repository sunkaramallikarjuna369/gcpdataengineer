# Cloud Storage

[![Cloud Storage](https://img.shields.io/badge/Cloud%20Storage-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/storage)
[![Difficulty: Beginner](https://img.shields.io/badge/Difficulty-Beginner-green?style=for-the-badge)](.)

> **Master Cloud Storage - Scalable Object Storage for Any Data**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Storage?

Google Cloud Storage is a unified object storage service for developers and enterprises. It offers high availability, durability (11 9's), and scalability for storing any amount of data. Cloud Storage is the foundation for data lakes, backup/archive, and serving static content.

---

## Storage Classes

| Class | Use Case | Min Duration | Availability |
|-------|----------|--------------|--------------|
| Standard | Frequent access | None | 99.99% |
| Nearline | Monthly access | 30 days | 99.9% |
| Coldline | Quarterly access | 90 days | 99.9% |
| Archive | Yearly access | 365 days | 99.9% |

---

## Quick Start

```bash
# Create bucket
gsutil mb -l us-central1 -c standard gs://my-bucket

# Upload files
gsutil cp file.txt gs://my-bucket/
gsutil cp -r folder/ gs://my-bucket/

# Download files
gsutil cp gs://my-bucket/file.txt .

# List objects
gsutil ls gs://my-bucket/

# Set lifecycle policy
gsutil lifecycle set lifecycle.json gs://my-bucket
```

---

## Python SDK

```python
from google.cloud import storage

client = storage.Client()
bucket = client.bucket('my-bucket')

# Upload
blob = bucket.blob('data/file.txt')
blob.upload_from_filename('local_file.txt')

# Download
blob.download_to_filename('downloaded.txt')

# List objects
for blob in bucket.list_blobs(prefix='data/'):
    print(blob.name)
```

---

## Lifecycle Management

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {"age": 30}
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

## Interview Tips

**Q: How do you choose the right storage class?**
> Based on access frequency: Standard for hot data, Nearline for monthly, Coldline for quarterly, Archive for yearly. Consider minimum storage duration charges.

**Q: How do you secure Cloud Storage buckets?**
> Use IAM for access control, enable uniform bucket-level access, use signed URLs for temporary access, enable object versioning, and use VPC Service Controls for sensitive data.

---

## Next Steps

- [Data Ingestion](../data-ingestion/) - Loading data into GCS
- [BigQuery](../bigquery-basics/) - Query data in GCS with external tables
