# =============================================================================
# Terraform Input Variables
# =============================================================================
# These variables allow users to customize the deployment without modifying code
# Values can be provided via terraform.tfvars, command line, or environment variables

# =============================================================================
# Project Configuration Variable
# =============================================================================
# Specifies which GCP project will contain all the created resources
variable "project_id" {
  description = "GCP project ID to use"
  # nullable = false ensures this variable must be provided (no default value)
  # This prevents accidental deployment to the wrong project
  nullable = false
}

# =============================================================================
# Region Configuration Variable
# =============================================================================
# Specifies the GCP region where most resources will be created
# This affects latency, compliance, and cost considerations
variable "region" {
  description = "GCP region to use for the creation of resources"
  # No nullable = false means this can have a default value if not specified
  # Users should choose a region close to their users or compliance requirements
}