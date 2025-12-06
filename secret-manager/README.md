# Secret Manager

[![Secret Manager](https://img.shields.io/badge/Secret%20Manager-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/secret-manager)
[![Difficulty: Beginner](https://img.shields.io/badge/Difficulty-Beginner-green?style=for-the-badge)](.)

> **Master Secret Manager - Secure Credential Storage**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Secret Manager?

Secret Manager is a secure and convenient storage system for API keys, passwords, certificates, and other sensitive data. It provides versioning, automatic rotation, and fine-grained IAM access control.

---

## Key Features

- **Versioning**: Track secret versions
- **Rotation**: Automatic secret rotation
- **IAM Integration**: Fine-grained access control
- **Audit Logging**: Track secret access
- **Regional/Global**: Choose replication policy

---

## Quick Start

```bash
# Create a secret
echo -n "my-api-key" | gcloud secrets create my-secret \
    --data-file=- \
    --replication-policy="automatic"

# Access a secret
gcloud secrets versions access latest --secret=my-secret

# Add new version
echo -n "new-api-key" | gcloud secrets versions add my-secret --data-file=-

# List versions
gcloud secrets versions list my-secret
```

---

## Python Usage

```python
from google.cloud import secretmanager

client = secretmanager.SecretManagerServiceClient()

# Access secret
name = f"projects/PROJECT_ID/secrets/my-secret/versions/latest"
response = client.access_secret_version(request={"name": name})
secret_value = response.payload.data.decode("UTF-8")

# Create secret
parent = f"projects/PROJECT_ID"
secret = client.create_secret(
    request={
        "parent": parent,
        "secret_id": "new-secret",
        "secret": {"replication": {"automatic": {}}},
    }
)

# Add version
client.add_secret_version(
    request={
        "parent": secret.name,
        "payload": {"data": b"secret-data"},
    }
)
```

---

## Data Pipeline Integration

```python
from google.cloud import secretmanager
from google.cloud import bigquery

def get_secret(secret_id):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/PROJECT_ID/secrets/{secret_id}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    return response.payload.data.decode("UTF-8")

# Use in pipeline
db_password = get_secret("database-password")
api_key = get_secret("external-api-key")
```

---

## Interview Tips

**Q: How do you manage secrets in data pipelines?**
> Use Secret Manager to store credentials, access them at runtime using service account permissions, implement secret rotation, and never hardcode secrets in code or configs.

**Q: How do you implement secret rotation?**
> Use Cloud Functions triggered by Pub/Sub to rotate secrets automatically. Update the secret version in Secret Manager and notify dependent services.

---

## Next Steps

- [Security](../security-compliance/) - Security best practices
- [IAM](../iam-security/) - Access control
