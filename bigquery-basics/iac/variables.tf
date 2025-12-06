# BigQuery Basics - Terraform Variables
# =====================================

variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
  
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty."
  }
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "location" {
  description = "The location for BigQuery datasets (US, EU, or specific region)"
  type        = string
  default     = "US"
  
  validation {
    condition     = contains(["US", "EU", "us-central1", "us-east1", "europe-west1"], var.location)
    error_message = "Location must be a valid BigQuery location."
  }
}

variable "environment" {
  description = "Environment label (learning, dev, prod)"
  type        = string
  default     = "learning"
}

variable "default_table_expiration_days" {
  description = "Default expiration for tables in days (0 = no expiration)"
  type        = number
  default     = 0
}
