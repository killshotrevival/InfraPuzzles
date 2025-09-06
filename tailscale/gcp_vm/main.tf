# =============================================================================
# Terraform Provider Configuration
# =============================================================================
# Configures the Google Cloud Platform provider for Terraform
# This tells Terraform which GCP project and region to use for resource creation
provider "google" {
  project = var.project_id  # GCP Project ID where resources will be created
  region  = var.region      # Default region for resources (can be overridden per resource)
}

# =============================================================================
# Project-Level Metadata Configuration
# =============================================================================
# Enables OS Login for the entire GCP project
# OS Login provides secure access to VM instances using IAM roles instead of SSH keys
resource "google_compute_project_metadata" "default" {
    metadata = {
      # Enable OS Login: Allows users to SSH to VMs using their Google identity
      # This provides better security than managing SSH keys manually
      # Users must have appropriate IAM roles (compute.osLogin) to access VMs
      enable-oslogin = "TRUE"
    }
}