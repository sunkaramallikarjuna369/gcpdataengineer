# Cloud Firestore

[![Firestore](https://img.shields.io/badge/Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://cloud.google.com/firestore)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Cloud Firestore - Flexible NoSQL Document Database**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Firestore?

Cloud Firestore is a flexible, scalable NoSQL document database for mobile, web, and server development. It keeps data in sync across client apps through real-time listeners and offers offline support. Firestore is ideal for applications requiring real-time updates and hierarchical data structures.

---

## Data Model

```
Collection: users
├── Document: user123
│   ├── name: "John Doe"
│   ├── email: "john@example.com"
│   └── Subcollection: orders
│       ├── Document: order1
│       └── Document: order2
└── Document: user456
```

---

## Quick Start

```python
from google.cloud import firestore

db = firestore.Client()

# Add document
doc_ref = db.collection('users').document('user123')
doc_ref.set({
    'name': 'John Doe',
    'email': 'john@example.com',
    'created': firestore.SERVER_TIMESTAMP
})

# Read document
doc = doc_ref.get()
print(doc.to_dict())

# Query
users = db.collection('users').where('name', '==', 'John Doe').stream()
for user in users:
    print(user.id, user.to_dict())

# Real-time listener
def on_snapshot(doc_snapshot, changes, read_time):
    for doc in doc_snapshot:
        print(f'Received: {doc.to_dict()}')

doc_ref.on_snapshot(on_snapshot)
```

---

## Interview Tips

**Q: When would you use Firestore vs Bigtable?**
> Firestore for mobile/web apps needing real-time sync, hierarchical data, and offline support. Bigtable for high-throughput analytics, time-series, and when you need HBase compatibility.

**Q: How do you design Firestore for scalability?**
> Denormalize data, use subcollections for one-to-many, avoid deep nesting, use composite indexes for complex queries, and be mindful of document size limits (1MB).

---

## Next Steps

- [Bigtable](../bigtable/) - High-throughput NoSQL
- [Data Modeling](../data-governance/) - Schema design patterns
