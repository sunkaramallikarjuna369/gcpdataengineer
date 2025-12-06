# GCP Fundamentals

[![GCP](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![Difficulty: Beginner](https://img.shields.io/badge/Difficulty-Beginner-green?style=for-the-badge)](.)

> **Master GCP Core Concepts - Projects, IAM, Billing, Networking**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Google Cloud Platform?

Google Cloud Platform (GCP) is a suite of cloud computing services that runs on the same infrastructure that Google uses internally for its end-user products. GCP provides compute, storage, networking, big data, machine learning, and IoT services, along with management tools.

The platform is organized around Projects, which serve as containers for resources and provide a boundary for billing, permissions, and API enablement. Understanding GCP's resource hierarchy (Organization > Folders > Projects > Resources) is fundamental to working effectively with any GCP service.

---

## Core Concepts

### Resource Hierarchy

```
Organization (company.com)
├── Folder (Engineering)
│   ├── Project (data-platform-prod)
│   │   ├── BigQuery Dataset
│   │   ├── GCS Bucket
│   │   └── Dataflow Job
│   └── Project (data-platform-dev)
└── Folder (Marketing)
    └── Project (analytics-prod)
```

### Identity and Access Management (IAM)

IAM lets you control who (identity) has what access (role) to which resources.

**Key Components:**
- **Principal**: Who is requesting access (user, service account, group)
- **Role**: Collection of permissions
- **Policy**: Binds principals to roles on a resource

**Role Types:**
- Basic Roles: Owner, Editor, Viewer (broad, use sparingly)
- Predefined Roles: Fine-grained, service-specific
- Custom Roles: User-defined permission sets

```bash
# Grant BigQuery Data Viewer role
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="user:analyst@company.com" \
    --role="roles/bigquery.dataViewer"

# List IAM policy
gcloud projects get-iam-policy PROJECT_ID
```

### Service Accounts

Service accounts are special accounts for applications and services.

```bash
# Create service account
gcloud iam service-accounts create my-sa \
    --display-name="My Service Account"

# Create and download key
gcloud iam service-accounts keys create key.json \
    --iam-account=my-sa@PROJECT_ID.iam.gserviceaccount.com
```

### Billing

- **Billing Account**: Pays for GCP usage
- **Budget Alerts**: Notifications at spending thresholds
- **Export**: Send billing data to BigQuery for analysis

```bash
# Set budget alert
gcloud billing budgets create \
    --billing-account=BILLING_ACCOUNT_ID \
    --display-name="Monthly Budget" \
    --budget-amount=1000USD \
    --threshold-rule=percent=50 \
    --threshold-rule=percent=90
```

### Networking (VPC)

Virtual Private Cloud provides networking for your resources.

```bash
# Create VPC
gcloud compute networks create my-vpc \
    --subnet-mode=custom

# Create subnet
gcloud compute networks subnets create my-subnet \
    --network=my-vpc \
    --region=us-central1 \
    --range=10.0.0.0/24
```

### Cloud Storage

Object storage for any amount of data.

**Storage Classes:**
- Standard: Frequent access
- Nearline: Monthly access
- Coldline: Quarterly access
- Archive: Yearly access

```bash
# Create bucket
gsutil mb -l us-central1 -c standard gs://my-bucket

# Upload file
gsutil cp file.txt gs://my-bucket/

# Set lifecycle policy
gsutil lifecycle set lifecycle.json gs://my-bucket
```

---

## Quick Start

```bash
# Install gcloud CLI
curl https://sdk.cloud.google.com | bash

# Initialize
gcloud init

# Set project
gcloud config set project PROJECT_ID

# Enable APIs
gcloud services enable bigquery.googleapis.com
gcloud services enable dataflow.googleapis.com
gcloud services enable pubsub.googleapis.com
```

---

## Interview Tips

**Q: Explain the GCP resource hierarchy.**
> Organization > Folders > Projects > Resources. IAM policies are inherited down the hierarchy. Projects are the basic unit for billing and API enablement.

**Q: What's the difference between a user account and service account?**
> User accounts are for humans and use OAuth. Service accounts are for applications, use keys or workload identity, and can be impersonated.

**Q: How do you implement least privilege in GCP?**
> Use predefined roles instead of basic roles, create custom roles when needed, use service accounts with minimal permissions, and regularly audit IAM policies.

---

## Hands-On Exercises

| Exercise | Description | Time |
|----------|-------------|------|
| [Exercise 1](./exercises/easy/01-create-project.md) | Create and configure a project | 15 min |
| [Exercise 2](./exercises/medium/01-iam-setup.md) | Set up IAM for a data team | 30 min |
| [Exercise 3](./exercises/hard/01-org-policy.md) | Implement organization policies | 45 min |

---

## Next Steps

- [Cloud Storage](../cloud-storage/) - Object storage deep dive
- [BigQuery Basics](../bigquery-basics/) - Data warehouse fundamentals
- [IAM Security](../iam-security/) - Advanced IAM patterns
