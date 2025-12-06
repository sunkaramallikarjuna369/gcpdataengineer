# Workflows

[![Workflows](https://img.shields.io/badge/Workflows-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/workflows)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Cloud Workflows - Serverless Orchestration**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Cloud Workflows?

Cloud Workflows is a fully managed orchestration platform that executes services in an order you define. It's serverless, scales automatically, and charges only for execution time. Use it to coordinate microservices, automate tasks, and build reliable data pipelines.

---

## Key Features

- **Serverless**: No infrastructure to manage
- **YAML/JSON**: Define workflows declaratively
- **Connectors**: Built-in GCP service connectors
- **Error Handling**: Retries, timeouts, error catching
- **Subworkflows**: Reusable workflow components

---

## Quick Start

```yaml
main:
  params: [input]
  steps:
    - init:
        assign:
          - project: ${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
          - dataset: "my_dataset"
    
    - runQuery:
        call: googleapis.bigquery.v2.jobs.query
        args:
          projectId: ${project}
          body:
            query: "SELECT COUNT(*) FROM `${project}.${dataset}.events`"
            useLegacySql: false
        result: queryResult
    
    - logResult:
        call: sys.log
        args:
          text: ${"Row count:" + string(queryResult.rows[0].f[0].v)}
    
    - returnResult:
        return: ${queryResult}
```

---

## Data Pipeline Example

```yaml
main:
  steps:
    - extractData:
        call: http.get
        args:
          url: https://api.example.com/data
        result: rawData
    
    - transformData:
        call: googleapis.cloudfunctions.v2.projects.locations.functions.call
        args:
          name: projects/PROJECT/locations/us-central1/functions/transform
          body:
            data: ${rawData.body}
        result: transformedData
    
    - loadToBigQuery:
        call: googleapis.bigquery.v2.tabledata.insertAll
        args:
          projectId: ${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
          datasetId: my_dataset
          tableId: my_table
          body:
            rows: ${transformedData}
```

---

## Error Handling

```yaml
main:
  steps:
    - tryStep:
        try:
          call: http.get
          args:
            url: https://api.example.com/data
          result: response
        retry:
          predicate: ${http.default_retry_predicate}
          max_retries: 3
          backoff:
            initial_delay: 1
            max_delay: 60
            multiplier: 2
        except:
          as: e
          steps:
            - handleError:
                call: sys.log
                args:
                  severity: ERROR
                  text: ${"Error:" + e.message}
```

---

## Interview Tips

**Q: When would you use Workflows vs Cloud Composer?**
> Workflows for simple orchestration, HTTP-based integrations, and when you want serverless. Cloud Composer for complex DAGs, heavy data processing, and when you need Airflow ecosystem.

**Q: How do you handle long-running operations in Workflows?**
> Use polling with `sys.sleep`, callbacks for async operations, or break into multiple workflow executions with Cloud Scheduler triggers.

---

## Next Steps

- [Cloud Composer](../cloud-composer/) - Complex orchestration
- [Cloud Functions](../cloud-functions/) - Serverless compute
