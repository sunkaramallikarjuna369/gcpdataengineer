# Cloud Spanner

[![Spanner](https://img.shields.io/badge/Cloud%20Spanner-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/spanner)
[![Difficulty: Advanced](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)](.)

> **Master Cloud Spanner - Globally Distributed Relational Database**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Spanner?

Cloud Spanner is a fully managed, horizontally scalable, globally distributed relational database service. It combines the benefits of relational databases (ACID transactions, SQL) with the scalability of NoSQL databases. Spanner provides strong consistency across regions and automatic sharding.

---

## Key Features

- **Global Distribution**: Multi-region with strong consistency
- **Horizontal Scaling**: Add nodes for more capacity
- **SQL Support**: Standard SQL with joins, indexes
- **ACID Transactions**: Distributed transactions
- **99.999% SLA**: Five 9s availability

---

## Quick Start

```python
from google.cloud import spanner

client = spanner.Client()
instance = client.instance('my-instance')
database = instance.database('my-database')

# Insert data
def insert_singer(transaction):
    transaction.insert(
        'Singers',
        columns=['SingerId', 'FirstName', 'LastName'],
        values=[(1, 'Marc', 'Richards')]
    )

database.run_in_transaction(insert_singer)

# Query data
with database.snapshot() as snapshot:
    results = snapshot.execute_sql(
        'SELECT SingerId, FirstName, LastName FROM Singers'
    )
    for row in results:
        print(row)
```

---

## Schema Design

```sql
CREATE TABLE Singers (
    SingerId INT64 NOT NULL,
    FirstName STRING(1024),
    LastName STRING(1024),
) PRIMARY KEY (SingerId);

CREATE TABLE Albums (
    SingerId INT64 NOT NULL,
    AlbumId INT64 NOT NULL,
    AlbumTitle STRING(MAX),
) PRIMARY KEY (SingerId, AlbumId),
  INTERLEAVE IN PARENT Singers ON DELETE CASCADE;
```

---

## Interview Tips

**Q: When would you use Spanner vs BigQuery?**
> Spanner for OLTP workloads requiring strong consistency, transactions, and low latency. BigQuery for OLAP, analytics, and when eventual consistency is acceptable.

**Q: How does Spanner achieve global consistency?**
> Spanner uses TrueTime (atomic clocks + GPS) to assign globally meaningful timestamps to transactions, enabling external consistency across regions.

---

## Next Steps

- [BigQuery](../bigquery-basics/) - Analytics on Spanner data
- [Dataflow](../dataflow-basics/) - CDC from Spanner
