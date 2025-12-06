# Exercise: Create Your First Dataset and Table

## Difficulty: Easy
## Time: 15 minutes

## Objective
Learn to create a BigQuery dataset and table using both the Console and CLI.

## Prerequisites
- GCP project with BigQuery API enabled
- `gcloud` CLI installed and authenticated

## Instructions

### Part 1: Using the Console

1. Go to [BigQuery Console](https://console.cloud.google.com/bigquery)
2. Click on your project name in the left panel
3. Click "CREATE DATASET"
4. Fill in:
   - Dataset ID: `my_first_dataset`
   - Data location: `US`
   - Default table expiration: Leave empty
5. Click "CREATE DATASET"

### Part 2: Using the CLI

```bash
# Create a dataset
bq mk --dataset \
    --location=US \
    --description="My first BigQuery dataset" \
    your-project-id:cli_dataset

# Verify it was created
bq ls
```

### Part 3: Create a Table

```bash
# Create a table with schema
bq mk --table \
    your-project-id:cli_dataset.users \
    id:INTEGER,name:STRING,email:STRING,created_at:TIMESTAMP

# Verify the table
bq show your-project-id:cli_dataset.users
```

## Expected Output

After completing this exercise, you should have:
- Two datasets: `my_first_dataset` and `cli_dataset`
- One table: `cli_dataset.users` with 4 columns

## Verification Query

```sql
SELECT 
    table_catalog,
    table_schema,
    table_name,
    creation_time
FROM `your-project-id.cli_dataset.INFORMATION_SCHEMA.TABLES`;
```

## Cleanup

```bash
# Delete the datasets (and all tables within)
bq rm -r -f your-project-id:my_first_dataset
bq rm -r -f your-project-id:cli_dataset
```

## Interview Question

**Q: What's the difference between a dataset and a table in BigQuery?**

A: A dataset is a container that holds tables, views, and other objects. It's similar to a schema in traditional databases. A table stores the actual data in columnar format. Datasets are used to organize and control access to tables - you can set permissions at the dataset level that apply to all tables within it.
