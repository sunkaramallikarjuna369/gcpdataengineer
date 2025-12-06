# GCP Data Engineering 360° - Job-Ready Mastery Repository

[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![Professional Data Engineer](https://img.shields.io/badge/Certification-Professional%20Data%20Engineer-success?style=for-the-badge)](https://cloud.google.com/certification/data-engineer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](http://makeapullrequest.com)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live%20Demos-blue?style=for-the-badge)](https://sunkaramallikarjuna369.github.io/gcpdataengineer/)

> **Your Complete Path to Google Cloud Professional Data Engineer Certification**

A comprehensive, enterprise-grade learning repository covering GCP Data Engineering from fundamentals to advanced production systems. Features interactive 3D visualizations, hands-on Python/SQL labs, and real-world exercises aligned with Google's certification exam.

## Interactive 3D Repository Map

<div align="center">
  <a href="./index.html">
    <img src="./assets/repo-map-preview.png" alt="3D Repository Map" width="800"/>
  </a>
  <p><em>Click to explore the interactive 3D fly-through of all modules</em></p>
</div>

[**Launch Interactive 3D Map**](./index.html) | [**Certification Simulator**](./certification-simulator/index.html) | [**Quick Start Guide**](#quick-start)

---

## What You'll Learn

This repository transforms you from a GCP beginner to a job-ready Data Engineer through:

- **50+ Comprehensive Modules** covering every aspect of GCP data engineering
- **Interactive 3D Visualizations** using Three.js for deep architectural understanding
- **Hands-on Labs** with Python notebooks, SQL queries, and CLI scripts
- **Real-world Exercises** with LeetCode-style challenges and interview prep
- **Infrastructure as Code** with Terraform for production deployments
- **Certification Prep** with 100+ practice questions and explanations

---

## Repository Structure

### Core Foundations
| Module | Description | Difficulty |
|--------|-------------|------------|
| [gcp-fundamentals](./gcp-fundamentals/) | IAM, Projects, Billing, VPC, Cloud Storage | Beginner |
| [cloud-storage-deep-dive](./cloud-storage-deep-dive/) | Buckets, Classes, Lifecycles, Transfer | Beginner |
| [networking-essentials](./networking-essentials/) | VPC, Subnets, Firewall, Private Access | Beginner |

### Data Ingestion & Integration
| Module | Description | Difficulty |
|--------|-------------|------------|
| [data-ingestion](./data-ingestion/) | Transfer Service, Storage Transfer, APIs | Beginner |
| [pubsub-messaging](./pubsub-messaging/) | Topics, Subscriptions, Dead-letter Queues | Intermediate |
| [datastream-cdc](./datastream-cdc/) | Change Data Capture, Real-time Replication | Intermediate |
| [data-fusion-pipelines](./data-fusion-pipelines/) | No-code ETL, Visual Pipeline Builder | Intermediate |
| [dataprep-cleaning](./dataprep-cleaning/) | Data Wrangling, Profiling, Transformation | Intermediate |

### Storage & Data Lake
| Module | Description | Difficulty |
|--------|-------------|------------|
| [storage-lake](./storage-lake/) | Cloud Storage Partitioning, Hierarchies | Intermediate |
| [biglake-unified](./biglake-unified/) | Unified Storage, External Tables | Intermediate |
| [iceberg-delta-gcs](./iceberg-delta-gcs/) | Open Table Formats on GCS | Advanced |

### Data Warehouse (BigQuery)
| Module | Description | Difficulty |
|--------|-------------|------------|
| [bigquery-basics](./bigquery-basics/) | Datasets, Tables, Views, Basic Queries | Beginner |
| [bigquery-advanced](./bigquery-advanced/) | Partitioning, Clustering, Slots | Intermediate |
| [bigquery-ml](./bigquery-ml/) | Machine Learning in SQL | Intermediate |
| [bigquery-scripting](./bigquery-scripting/) | Stored Procedures, UDFs, Scripting | Intermediate |
| [bigquery-gis](./bigquery-gis/) | Geospatial Analytics | Advanced |
| [bigquery-bi-engine](./bigquery-bi-engine/) | In-memory Analysis, BI Acceleration | Advanced |
| [bigquery-federated](./bigquery-federated/) | External Data Sources, Federated Queries | Advanced |

### Batch Processing
| Module | Description | Difficulty |
|--------|-------------|------------|
| [batch-etl](./batch-etl/) | ETL Patterns, Best Practices | Intermediate |
| [dataflow-batch](./dataflow-batch/) | Apache Beam Batch Pipelines | Intermediate |
| [dataflow-templates](./dataflow-templates/) | Pre-built & Custom Templates | Intermediate |
| [dataproc-spark](./dataproc-spark/) | Spark on GCP, Cluster Management | Intermediate |
| [dataproc-hadoop](./dataproc-hadoop/) | Hadoop Ecosystem on GCP | Intermediate |

### Stream Processing
| Module | Description | Difficulty |
|--------|-------------|------------|
| [streaming](./streaming/) | Real-time Data Processing Patterns | Intermediate |
| [dataflow-streaming](./dataflow-streaming/) | Streaming Pipelines, Windows, Triggers | Advanced |
| [pubsub-dataflow-integration](./pubsub-dataflow-integration/) | End-to-end Streaming Architecture | Advanced |
| [spanner-change-streams](./spanner-change-streams/) | Database Change Capture | Advanced |

### Orchestration
| Module | Description | Difficulty |
|--------|-------------|------------|
| [orchestration](./orchestration/) | Workflow Management Patterns | Intermediate |
| [cloud-composer](./cloud-composer/) | Managed Airflow, DAGs, Operators | Intermediate |
| [composer-advanced](./composer-advanced/) | Sensors, SLA Monitoring, Best Practices | Advanced |
| [airflow-migration](./airflow-migration/) | On-prem to Cloud Composer Migration | Advanced |
| [dataform-transformations](./dataform-transformations/) | SQL-based Transformations, Version Control | Intermediate |

### ML & AI Operations
| Module | Description | Difficulty |
|--------|-------------|------------|
| [ml-ops](./ml-ops/) | MLOps Patterns on GCP | Intermediate |
| [vertex-ai-pipelines](./vertex-ai-pipelines/) | End-to-end ML Pipelines | Advanced |
| [vertex-feature-store](./vertex-feature-store/) | Feature Engineering & Serving | Advanced |
| [model-garden](./model-garden/) | Pre-trained Models, Fine-tuning | Advanced |

### Security & Compliance
| Module | Description | Difficulty |
|--------|-------------|------------|
| [security-compliance](./security-compliance/) | Security Best Practices Overview | Intermediate |
| [iam-deep-dive](./iam-deep-dive/) | Roles, Policies, Service Accounts | Intermediate |
| [dlp-data-protection](./dlp-data-protection/) | Sensitive Data Detection & Masking | Intermediate |
| [vpc-service-controls](./vpc-service-controls/) | Security Perimeters, Access Levels | Advanced |
| [audit-logging](./audit-logging/) | Cloud Audit Logs, Compliance | Intermediate |
| [encryption-at-rest](./encryption-at-rest/) | CMEK, Column-level Encryption | Advanced |

### Monitoring & Optimization
| Module | Description | Difficulty |
|--------|-------------|------------|
| [monitoring-optimization](./monitoring-optimization/) | Observability Overview | Intermediate |
| [cloud-monitoring](./cloud-monitoring/) | Metrics, Dashboards, Alerts | Intermediate |
| [cloud-logging](./cloud-logging/) | Log Management, Analysis | Intermediate |
| [cost-optimization](./cost-optimization/) | FinOps, Reservations, Budgets | Intermediate |
| [performance-tuning](./performance-tuning/) | Query Optimization, Autoscaling | Advanced |

### Advanced Topics
| Module | Description | Difficulty |
|--------|-------------|------------|
| [advanced](./advanced/) | Advanced Patterns Overview | Advanced |
| [multi-region-architecture](./multi-region-architecture/) | Global Data Distribution | Advanced |
| [disaster-recovery](./disaster-recovery/) | DR Strategies, RTO/RPO | Advanced |
| [hybrid-connectivity](./hybrid-connectivity/) | Cloud Interconnect, VPN | Advanced |
| [looker-studio-integration](./looker-studio-integration/) | BI & Visualization | Intermediate |

### Specialized Services
| Module | Description | Difficulty |
|--------|-------------|------------|
| [data-catalog](./data-catalog/) | Metadata Management, Lineage | Intermediate |
| [alloydb-oltp](./alloydb-oltp/) | PostgreSQL-compatible OLTP | Intermediate |
| [firestore-nosql](./firestore-nosql/) | Document Database | Intermediate |
| [cloud-sql](./cloud-sql/) | Managed MySQL/PostgreSQL | Beginner |
| [spanner-global](./spanner-global/) | Globally Distributed Database | Advanced |
| [memorystore-caching](./memorystore-caching/) | Redis/Memcached Caching | Intermediate |

### Operations & Best Practices
| Module | Description | Difficulty |
|--------|-------------|------------|
| [finops-best-practices](./finops-best-practices/) | Cost Management Strategies | Intermediate |
| [secops-siem](./secops-siem/) | Security Operations | Advanced |
| [devops-cicd](./devops-cicd/) | CI/CD for Data Pipelines | Intermediate |
| [testing-strategies](./testing-strategies/) | Unit, Integration, E2E Testing | Intermediate |

---

## Quick Start

### Prerequisites

1. **Google Cloud Account** (Free tier available)
   ```bash
   # Sign up at https://cloud.google.com/free
   ```

2. **Google Cloud SDK**
   ```bash
   # Install gcloud CLI
   curl https://sdk.cloud.google.com | bash
   exec -l $SHELL
   gcloud init
   ```

3. **Python 3.9+**
   ```bash
   python3 --version
   pip install -r requirements.txt
   ```

4. **Terraform** (for IaC labs)
   ```bash
   # Install Terraform
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

5. **VS Code Extensions** (Recommended)
   - Google Cloud Code
   - Python
   - Jupyter
   - Terraform
   - SQL Tools

### One-Click Setup

```bash
# Clone the repository
git clone https://github.com/sunkaramallikarjuna369/gcpdataengineer.git
cd gcpdataengineer

# Run setup script (configures GCP, installs dependencies)
chmod +x setup.sh
./setup.sh

# Launch interactive 3D map
open index.html  # or python -m http.server 8000
```

### Free Tier Limits

This repository is designed to work within GCP's free tier:
- BigQuery: 1TB queries/month, 10GB storage
- Cloud Storage: 5GB standard storage
- Pub/Sub: 10GB messages/month
- Dataflow: Limited free tier
- Cloud Functions: 2M invocations/month

---

## Learning Path

### Beginner Track (Weeks 1-4)
```
gcp-fundamentals → cloud-storage-deep-dive → bigquery-basics → data-ingestion
```

### Intermediate Track (Weeks 5-8)
```
pubsub-messaging → dataflow-batch → cloud-composer → security-compliance
```

### Advanced Track (Weeks 9-12)
```
dataflow-streaming → vertex-ai-pipelines → multi-region-architecture → disaster-recovery
```

### Certification Fast Track (2 Weeks)
```
All modules + certification-simulator (100+ practice questions)
```

---

## Certification Prep Checklist

- [ ] **Data Storage** - BigQuery, Cloud Storage, Bigtable, Spanner
- [ ] **Data Processing** - Dataflow, Dataproc, Pub/Sub
- [ ] **Data Pipelines** - Cloud Composer, Data Fusion
- [ ] **Machine Learning** - BigQuery ML, Vertex AI
- [ ] **Security** - IAM, DLP, VPC Service Controls
- [ ] **Monitoring** - Cloud Monitoring, Logging, Error Reporting
- [ ] **Cost Optimization** - Reservations, Slots, Autoscaling

[**Start Certification Simulator**](./certification-simulator/index.html)

---

## Interactive 3D Visualizations

Each module includes cutting-edge Three.js visualizations:

- **Rotatable 3D Architecture Diagrams** - Explore GCP services in 3D space
- **Particle Data Flow Animations** - Watch data move through pipelines
- **Explodable Components** - Click to see internal architecture
- **Real-time Metrics Simulation** - Interactive latency/throughput displays
- **Dark Mode Cyberpunk Aesthetic** - Neon-glowing nodes and connections

### Featured Visualizations

| Module | Visualization |
|--------|---------------|
| BigQuery | Exploding table partitions, slot allocation animation |
| Dataflow | Glowing pipeline with streaming particles |
| Pub/Sub | Orbiting message swarm (billions of particles) |
| Composer | DAG dependency graph with execution flow |

---

## Contributing

We welcome contributions! Please see our [Contributing Guide](./CONTRIBUTING.md).

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Ideas

- Add new modules for emerging GCP services
- Improve 3D visualizations
- Add more practice questions
- Translate content to other languages
- Fix bugs and improve documentation

---

## Community

- **Discord**: [Join our community](https://discord.gg/gcp-data-engineering)
- **YouTube**: [Video tutorials playlist](https://youtube.com/playlist?list=gcp-data-engineering)
- **Twitter**: [@GCPDataEng](https://twitter.com/GCPDataEng)

---

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

## Acknowledgments

- Google Cloud Documentation
- Apache Beam Community
- Three.js Contributors
- All our amazing contributors

---

<div align="center">
  <strong>Built with passion for the GCP Data Engineering community</strong>
  <br><br>
  <a href="https://cloud.google.com/certification/data-engineer">
    <img src="https://img.shields.io/badge/Get%20Certified-Professional%20Data%20Engineer-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white" alt="Get Certified"/>
  </a>
</div>
