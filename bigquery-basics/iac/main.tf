# BigQuery Basics - Terraform Infrastructure
# ==========================================
# This Terraform configuration creates BigQuery resources for the labs

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

# Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "location" {
  description = "BigQuery dataset location"
  type        = string
  default     = "US"
}

# Provider configuration
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable BigQuery API
resource "google_project_service" "bigquery" {
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

# Create BigQuery Dataset
resource "google_bigquery_dataset" "labs_dataset" {
  dataset_id    = "gcp_data_eng_labs"
  friendly_name = "GCP Data Engineering Labs"
  description   = "Dataset for GCP Data Engineering learning exercises"
  location      = var.location

  labels = {
    environment = "learning"
    module      = "bigquery-basics"
  }

  # Default table expiration (optional - 30 days)
  # default_table_expiration_ms = 2592000000

  depends_on = [google_project_service.bigquery]
}

# Create sample tables
resource "google_bigquery_table" "users" {
  dataset_id = google_bigquery_dataset.labs_dataset.dataset_id
  table_id   = "users"

  schema = jsonencode([
    {
      name = "id"
      type = "INTEGER"
      mode = "REQUIRED"
      description = "User ID"
    },
    {
      name = "name"
      type = "STRING"
      mode = "REQUIRED"
      description = "User name"
    },
    {
      name = "email"
      type = "STRING"
      mode = "NULLABLE"
      description = "User email"
    },
    {
      name = "created_at"
      type = "TIMESTAMP"
      mode = "REQUIRED"
      description = "Account creation timestamp"
    },
    {
      name = "is_active"
      type = "BOOLEAN"
      mode = "NULLABLE"
      description = "Whether user is active"
    }
  ])

  labels = {
    environment = "learning"
  }
}

# Create partitioned table
resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.labs_dataset.dataset_id
  table_id   = "events"

  schema = jsonencode([
    {
      name = "event_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "user_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "event_type"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "event_timestamp"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    },
    {
      name = "event_date"
      type = "DATE"
      mode = "REQUIRED"
    },
    {
      name = "properties"
      type = "JSON"
      mode = "NULLABLE"
    }
  ])

  time_partitioning {
    type  = "DAY"
    field = "event_date"
  }

  clustering = ["user_id", "event_type"]

  labels = {
    environment = "learning"
    partitioned = "true"
  }
}

# Create a view
resource "google_bigquery_table" "active_users_view" {
  dataset_id = google_bigquery_dataset.labs_dataset.dataset_id
  table_id   = "active_users_view"

  view {
    query          = "SELECT * FROM `${var.project_id}.${google_bigquery_dataset.labs_dataset.dataset_id}.users` WHERE is_active = TRUE"
    use_legacy_sql = false
  }

  depends_on = [google_bigquery_table.users]
}

# IAM binding for dataset
resource "google_bigquery_dataset_iam_member" "viewer" {
  dataset_id = google_bigquery_dataset.labs_dataset.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "allAuthenticatedUsers"  # For learning purposes only!
}

# Outputs
output "dataset_id" {
  description = "The ID of the created dataset"
  value       = google_bigquery_dataset.labs_dataset.dataset_id
}

output "dataset_self_link" {
  description = "The self link of the dataset"
  value       = google_bigquery_dataset.labs_dataset.self_link
}

output "users_table_id" {
  description = "The ID of the users table"
  value       = google_bigquery_table.users.table_id
}

output "events_table_id" {
  description = "The ID of the events table"
  value       = google_bigquery_table.events.table_id
}
