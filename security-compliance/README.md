# Security & Compliance

[![Security](https://img.shields.io/badge/Security-EA4335?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/security)
[![Difficulty: Advanced](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)](.)

> **Master GCP Security - Protect Your Data Engineering Infrastructure**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## Overview

Security in GCP data engineering encompasses identity management, data protection, network security, and compliance. This module covers IAM best practices, DLP for sensitive data, VPC Service Controls, encryption, and audit logging.

---

## IAM Best Practices

### Principle of Least Privilege
```bash
# Grant specific role instead of Editor
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="user:analyst@company.com" \
    --role="roles/bigquery.dataViewer"

# Use conditions for time-limited access
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="user:contractor@company.com" \
    --role="roles/bigquery.dataViewer" \
    --condition='expression=request.time < timestamp("2024-12-31T00:00:00Z"),title=temp-access'
```

### Service Account Security
```bash
# Create dedicated service account
gcloud iam service-accounts create dataflow-sa \
    --display-name="Dataflow Service Account"

# Grant minimal permissions
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:dataflow-sa@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/dataflow.worker"
```

---

## Data Loss Prevention (DLP)

Automatically discover and protect sensitive data:

```python
from google.cloud import dlp_v2

dlp = dlp_v2.DlpServiceClient()

# Inspect BigQuery table for PII
inspect_job = {
    'storage_config': {
        'big_query_options': {
            'table_reference': {
                'project_id': 'project',
                'dataset_id': 'dataset',
                'table_id': 'table'
            }
        }
    },
    'inspect_config': {
        'info_types': [
            {'name': 'EMAIL_ADDRESS'},
            {'name': 'PHONE_NUMBER'},
            {'name': 'CREDIT_CARD_NUMBER'}
        ]
    },
    'actions': [{'save_findings': {'output_config': {'table': {...}}}}]
}

dlp.create_dlp_job(parent=f'projects/{project}', inspect_job=inspect_job)
```

---

## VPC Service Controls

Create security perimeters around GCP resources:

```bash
# Create access policy
gcloud access-context-manager policies create \
    --organization=ORG_ID \
    --title="Data Platform Policy"

# Create service perimeter
gcloud access-context-manager perimeters create data-perimeter \
    --policy=POLICY_ID \
    --title="Data Platform Perimeter" \
    --resources="projects/PROJECT_NUMBER" \
    --restricted-services="bigquery.googleapis.com,storage.googleapis.com"
```

---

## Column-Level Security (BigQuery)

```sql
-- Create policy tag taxonomy
-- Then apply to columns in BigQuery

-- Grant access to specific users
GRANT `roles/datacatalog.categoryFineGrainedReader`
ON POLICY TAG `projects/project/locations/us/taxonomies/123/policyTags/456`
TO "user:analyst@company.com";
```

---

## Audit Logging

```bash
# Enable data access logs
gcloud logging sinks create bigquery-audit-sink \
    bigquery.googleapis.com/projects/PROJECT_ID/datasets/audit_logs \
    --log-filter='resource.type="bigquery_resource"'
```

---

## Interview Tips

**Q: How do you implement defense in depth for data pipelines?**
> Layer security: IAM for identity, VPC Service Controls for network perimeter, DLP for data classification, encryption for data at rest/transit, and audit logs for monitoring.

**Q: How do you handle PII in BigQuery?**
> Use DLP to discover PII, apply policy tags for column-level security, use authorized views to mask data, and implement row-level security with session user functions.

---

## Next Steps

- [IAM Security](../iam-security/) - Deep dive into IAM
- [DLP Security](../dlp-security/) - Data loss prevention
- [Audit Logging](../audit-logging/) - Monitoring and compliance
