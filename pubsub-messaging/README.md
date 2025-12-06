# Pub/Sub Messaging

[![Pub/Sub](https://img.shields.io/badge/Pub%2FSub-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/pubsub)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Google Cloud Pub/Sub - Scalable Messaging for Event-Driven Architectures**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Pub/Sub?

Google Cloud Pub/Sub is a fully managed, real-time messaging service that allows you to send and receive messages between independent applications. It follows the publish-subscribe pattern where publishers send messages to topics, and subscribers receive messages from subscriptions attached to those topics.

Pub/Sub decouples services that produce events from services that process events. This decoupling enables independent scaling, reliability through message persistence, and flexibility in how messages are consumed. Messages are stored for up to 7 days (configurable), ensuring delivery even if subscribers are temporarily unavailable.

The service handles billions of messages per day with low latency and high throughput. It's the backbone of many real-time data pipelines on GCP, commonly used with Dataflow for stream processing and BigQuery for analytics.

---

## Why Use Pub/Sub?

**Business Value:**
- **Decoupled Architecture**: Services communicate without direct dependencies
- **Scalability**: Handles millions of messages per second automatically
- **Reliability**: At-least-once delivery with message persistence
- **Global Reach**: Multi-region message routing
- **Cost Effective**: Pay only for what you use

**Technical Advantages:**
- Push and pull delivery modes
- Exactly-once processing (with Dataflow)
- Dead-letter queues for failed messages
- Message filtering and ordering
- Schema validation with Schema Registry

---

## When to Use Pub/Sub?

**Ideal Use Cases:**
- Event-driven microservices communication
- Real-time analytics pipelines
- Log and event aggregation
- IoT data ingestion
- Async task processing
- Cross-service notifications

**Not Ideal For:**
- Request-response patterns (use HTTP/gRPC)
- Very low latency (<10ms) requirements
- Small-scale, simple integrations
- Guaranteed ordering across all messages (use Kafka)

---

## How It Works

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      Pub/Sub Architecture                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐         ┌─────────────┐                        │
│  │ Publisher 1 │────────▶│             │                        │
│  └─────────────┘         │             │    ┌─────────────┐     │
│                          │    Topic    │───▶│Subscription │───▶ Subscriber
│  ┌─────────────┐         │             │    │     A       │     │
│  │ Publisher 2 │────────▶│             │    └─────────────┘     │
│  └─────────────┘         │             │                        │
│                          │             │    ┌─────────────┐     │
│  ┌─────────────┐         │             │───▶│Subscription │───▶ Subscriber
│  │ Publisher N │────────▶│             │    │     B       │     │
│  └─────────────┘         └─────────────┘    └─────────────┘     │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Key Concepts

1. **Topic**: Named resource to which messages are sent
2. **Subscription**: Named resource representing a message stream
3. **Message**: Data + attributes published to a topic
4. **Publisher**: Application that creates and sends messages
5. **Subscriber**: Application that receives messages
6. **Acknowledgment**: Confirmation that message was processed

### Quick Start

```bash
# Enable Pub/Sub API
gcloud services enable pubsub.googleapis.com

# Create a topic
gcloud pubsub topics create my-topic

# Create a subscription
gcloud pubsub subscriptions create my-sub --topic=my-topic

# Publish a message
gcloud pubsub topics publish my-topic --message="Hello, Pub/Sub!"

# Pull messages
gcloud pubsub subscriptions pull my-sub --auto-ack
```

### Python Quick Start

```python
from google.cloud import pubsub_v1

# Publisher
publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path('project-id', 'my-topic')

data = "Hello, Pub/Sub!".encode('utf-8')
future = publisher.publish(topic_path, data, attribute1='value1')
print(f"Published message ID: {future.result()}")

# Subscriber
subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path('project-id', 'my-sub')

def callback(message):
    print(f"Received: {message.data.decode('utf-8')}")
    message.ack()

streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
streaming_pull_future.result(timeout=60)
```

---

## Prerequisites Setup

```bash
# Enable API
gcloud services enable pubsub.googleapis.com

# Create service account
gcloud iam service-accounts create pubsub-sa \
    --display-name="Pub/Sub Service Account"

# Grant roles
gcloud projects add-iam-policy-binding your-project \
    --member="serviceAccount:pubsub-sa@your-project.iam.gserviceaccount.com" \
    --role="roles/pubsub.publisher"

gcloud projects add-iam-policy-binding your-project \
    --member="serviceAccount:pubsub-sa@your-project.iam.gserviceaccount.com" \
    --role="roles/pubsub.subscriber"
```

---

## Hands-On Labs

| Lab | Description | Time |
|-----|-------------|------|
| [Lab 1](./python-labs/01-basics.ipynb) | Topics, subscriptions, publish/subscribe | 30 min |
| [Lab 2](./python-labs/02-advanced.ipynb) | Dead-letter queues, ordering, filtering | 45 min |
| [Lab 3](./python-labs/03-dataflow-integration.ipynb) | Pub/Sub to BigQuery with Dataflow | 60 min |

---

## Interview Tips

**Q: What's the difference between push and pull subscriptions?**
> Pull: Subscriber explicitly requests messages. Better for batch processing and when subscriber controls rate.
> Push: Pub/Sub sends messages to an HTTP endpoint. Better for serverless (Cloud Functions/Run) and real-time processing.

**Q: How do you handle message ordering in Pub/Sub?**
> Use ordering keys. Messages with the same ordering key are delivered in order. Enable ordering on the subscription and publish with ordering keys.

**Q: What happens to unacknowledged messages?**
> They're redelivered after the ack deadline (default 10s). After max delivery attempts, they go to a dead-letter topic if configured.

---

## Teardown

```bash
gcloud pubsub subscriptions delete my-sub
gcloud pubsub topics delete my-topic
```

---

## Next Steps

- [Dataflow Streaming](../dataflow-streaming/) - Process Pub/Sub messages
- [Cloud Functions](../cloud-functions/) - Serverless Pub/Sub triggers
