# Cloud Bigtable

[![Bigtable](https://img.shields.io/badge/Bigtable-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/bigtable)
[![Difficulty: Advanced](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)](.)

> **Master Cloud Bigtable - Petabyte-Scale NoSQL Database**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Bigtable?

Cloud Bigtable is a fully managed, scalable NoSQL database service for large analytical and operational workloads. It's the same database that powers Google Search, Maps, and Gmail. Bigtable excels at single-digit millisecond latency for both reads and writes at any scale.

---

## Key Features

- **Massive Scale**: Petabytes of data, millions of ops/sec
- **Low Latency**: Single-digit millisecond response times
- **High Throughput**: Linear scaling with nodes
- **HBase Compatible**: Use existing HBase tools
- **Replication**: Multi-region for HA and DR

---

## Data Model

```
Row Key: user#12345#2024-01-15
├── Column Family: profile
│   ├── name: "John Doe"
│   └── email: "john@example.com"
└── Column Family: activity
    ├── last_login: "2024-01-15T10:30:00Z"
    └── page_views: "1523"
```

---

## Quick Start

```python
from google.cloud import bigtable
from google.cloud.bigtable import column_family

# Create client and instance
client = bigtable.Client(project='your-project', admin=True)
instance = client.instance('my-instance')

# Create table with column family
table = instance.table('my-table')
cf = table.column_family('cf1', gc_rule=column_family.MaxVersionsGCRule(1))
cf.create()

# Write data
row = table.direct_row('user#12345')
row.set_cell('cf1', 'name', 'John Doe')
row.set_cell('cf1', 'email', 'john@example.com')
row.commit()

# Read data
row = table.read_row('user#12345')
print(row.cells['cf1']['name'][0].value.decode('utf-8'))
```

---

## Row Key Design

Good row key design is critical for Bigtable performance:

- **Avoid hotspots**: Don't use monotonically increasing keys
- **Reverse timestamps**: For time-series, use `MAX_TIMESTAMP - timestamp`
- **Composite keys**: Combine multiple fields for range scans
- **Hash prefixes**: Distribute load across nodes

---

## Interview Tips

**Q: When would you use Bigtable vs BigQuery?**
> Bigtable for low-latency operational workloads, time-series data, and real-time analytics. BigQuery for ad-hoc analytical queries, complex joins, and when latency isn't critical.

**Q: How do you avoid hotspots in Bigtable?**
> Design row keys to distribute writes evenly. Avoid sequential keys, use field promotion, reverse timestamps, or add hash prefixes.

---

## Next Steps

- [Streaming](../streaming/) - Real-time data to Bigtable
- [Dataflow](../dataflow-basics/) - ETL to Bigtable
