# Streaming Data Processing

[![GCP](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![Difficulty: Advanced](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)](.)

> **Master Streaming - Real-Time Data Processing on GCP**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## Overview

Streaming data processing handles continuous, unbounded data flows in real-time. On GCP, the primary pattern is Pub/Sub for ingestion and Dataflow for processing, with BigQuery or Bigtable as destinations.

---

## Streaming Architecture

```
Sources → Pub/Sub → Dataflow → BigQuery/Bigtable
   ↓
Events → Topic → Streaming Pipeline → Analytics
```

---

## Key Concepts

### Windowing
Group unbounded data into finite chunks for processing.

- **Fixed Windows**: Non-overlapping, fixed-size time intervals
- **Sliding Windows**: Overlapping windows for moving averages
- **Session Windows**: Activity-based, gap-triggered windows

```python
import apache_beam as beam
from apache_beam import window

(pipeline
 | beam.WindowInto(window.FixedWindows(60))  # 60-second windows
 | beam.CombineGlobally(sum).without_defaults()
)
```

### Watermarks
Track event-time progress to handle late data.

```python
(pipeline
 | beam.WindowInto(
     window.FixedWindows(60),
     allowed_lateness=beam.Duration(seconds=300)
   )
)
```

### Triggers
Control when to emit results.

```python
from apache_beam.transforms.trigger import AfterWatermark, AfterProcessingTime, AccumulationMode

(pipeline
 | beam.WindowInto(
     window.FixedWindows(60),
     trigger=AfterWatermark(early=AfterProcessingTime(30)),
     accumulation_mode=AccumulationMode.DISCARDING
   )
)
```

---

## Pub/Sub to BigQuery

```python
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

options = PipelineOptions([
    '--runner=DataflowRunner',
    '--streaming',
    '--project=your-project',
    '--region=us-central1',
])

with beam.Pipeline(options=options) as p:
    (p
     | 'Read' >> beam.io.ReadFromPubSub(subscription='projects/proj/subscriptions/sub')
     | 'Parse' >> beam.Map(lambda x: json.loads(x))
     | 'Window' >> beam.WindowInto(beam.window.FixedWindows(60))
     | 'Aggregate' >> beam.CombineGlobally(sum).without_defaults()
     | 'Write' >> beam.io.WriteToBigQuery('project:dataset.table')
    )
```

---

## Interview Tips

**Q: How do you handle late data in streaming?**
> Use watermarks to track event-time progress, configure allowed lateness to accept late data, and use triggers to emit early/late results. Design downstream systems to handle updates.

**Q: What's the difference between event time and processing time?**
> Event time is when the event occurred (embedded in data). Processing time is when the event is processed. Use event time for accurate analytics; processing time for simpler, lower-latency scenarios.

---

## Next Steps

- [Pub/Sub](../pubsub-messaging/) - Event ingestion
- [Dataflow](../dataflow-basics/) - Stream processing
- [Bigtable](../bigtable/) - Low-latency storage
