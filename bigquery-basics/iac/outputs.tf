# BigQuery Basics - Terraform Outputs
# ====================================

output "dataset_id" {
  description = "The ID of the created BigQuery dataset"
  value       = google_bigquery_dataset.labs_dataset.dataset_id
}

output "dataset_location" {
  description = "The location of the dataset"
  value       = google_bigquery_dataset.labs_dataset.location
}

output "dataset_self_link" {
  description = "The URI of the dataset"
  value       = google_bigquery_dataset.labs_dataset.self_link
}

output "users_table_id" {
  description = "The full ID of the users table"
  value       = "${var.project_id}.${google_bigquery_dataset.labs_dataset.dataset_id}.${google_bigquery_table.users.table_id}"
}

output "events_table_id" {
  description = "The full ID of the events table"
  value       = "${var.project_id}.${google_bigquery_dataset.labs_dataset.dataset_id}.${google_bigquery_table.events.table_id}"
}

output "console_url" {
  description = "URL to view the dataset in BigQuery Console"
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}&d=${google_bigquery_dataset.labs_dataset.dataset_id}&p=${var.project_id}&page=dataset"
}
