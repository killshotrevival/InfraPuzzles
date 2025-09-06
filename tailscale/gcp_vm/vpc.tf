# =============================================================================
# VPC (Virtual Private Cloud) Configuration
# =============================================================================
# This creates a custom VPC network in Google Cloud Platform
# A VPC is a virtual network that provides isolation and control over network traffic
resource "google_compute_network" "vpc" {
  name                    = "public-vpc"
  # Disable automatic subnet creation - we want full control over subnet configuration
  auto_create_subnetworks = "false"
  description = "This VPC will be used for deploying resources that are internet facing."
}

# =============================================================================
# Subnet Configuration
# =============================================================================
# Creates a subnet within the VPC for organizing and isolating resources
# Subnets define IP address ranges and are regional resources
resource "google_compute_subnetwork" "subnet" {
  name          = "public-vpc-subnet-1"
  region        = var.region
  network       = google_compute_network.vpc.name
  # IP range: 10.10.0.0/24 provides 254 usable IP addresses (10.10.0.1 - 10.10.0.254)
  ip_cidr_range = "10.10.0.0/24"
  
  # VPC Flow Logs configuration for network monitoring and security analysis
  log_config {
    # Collect flow logs every 5 minutes for better granularity
    aggregation_interval = "INTERVAL_5_MIN"
    # Sample 50% of flows to balance monitoring detail with cost
    flow_sampling        = 0.5
    # Exclude metadata to reduce log size and cost
    metadata             = "EXCLUDE_ALL_METADATA"
    metadata_fields      = []
  }
}

# =============================================================================
# Default Deny Firewall Rule
# =============================================================================
# Implements the principle of least privilege by denying all traffic by default
# This is a security best practice - only explicitly allowed traffic can pass
resource "google_compute_firewall" "default-deny" {
  name    = "default-deny"
  network = google_compute_network.vpc.name
  description = "Deny all traffic coming towards the VPC by default"
  
  # Deny all TCP traffic (most common protocol)
  deny {
    protocol = "tcp"
  }

  # High priority (1000) ensures this rule is evaluated first
  # Lower numbers = higher priority in GCP firewall rules
  priority = 1000

  # Apply to all source IPs (0.0.0.0/0 means everywhere on the internet)
  source_ranges = [
    "0.0.0.0/0"
  ]
}


# =============================================================================
# SSH Access Firewall Rule
# =============================================================================
# Allows SSH access to instances with the "tailscale" tag
# Uses GCP Identity-Aware Proxy (IAP) for secure access without exposing SSH to the internet
resource "google_compute_firewall" "allow-ssh-connection" {
  name    = "allow-ssh-connection"
  network = google_compute_network.vpc.name
  description = "Allow ssh connection from GCP Identity aware proxy IP addresses range"

  # Allow TCP traffic on port 22 (SSH)
  allow {
    protocol = "tcp"
    ports    = [
      "22", # SSH port
    ]
  }

  # Only apply this rule to instances tagged with "tailscale"
  # This provides granular control over which instances can be accessed
  target_tags = [ "tailscale" ]

  # Priority 999 (lower than default-deny) allows this rule to override the deny rule
  priority = 999

  # Restrict access to GCP Identity-Aware Proxy IP range only
  # This ensures SSH access goes through IAP for authentication and authorization
  source_ranges = [
    "35.235.240.0/20", # GCP Identity aware proxy IP addresses range
  ]
}

# =============================================================================
# Tailscale UDP IPv4 Firewall Rule
# =============================================================================
# Allows Tailscale mesh networking traffic on UDP port 41641 for IPv4
# Tailscale uses this port for peer-to-peer communication in the mesh network
# Reference: https://tailscale.com/kb/1147/cloud-gce#step-2-allow-udp-port-41641
resource "google_compute_firewall" "tailscale-udp-ipv4" {
  name    = "tailscale-udp-ipv4"
  network = google_compute_network.vpc.name
  description = "UDP port for tailscale IPv4"

  # Allow UDP traffic on port 41641 (Tailscale's standard port)
  allow {
    protocol = "udp"
    ports    = [
      "41641", # Tailscale UDP port for mesh networking
    ]
  }

  # Only apply to instances tagged with "tailscale"
  target_tags = [ "tailscale" ]

  # Priority 999 allows this to override the default deny rule
  priority = 999

  # Allow from any source (0.0.0.0/0) as Tailscale peers can be anywhere
  # Tailscale handles authentication and encryption, so this is secure
  source_ranges = [
    "0.0.0.0/0"
  ]
}

# =============================================================================
# Tailscale UDP IPv6 Firewall Rule
# =============================================================================
# Allows Tailscale mesh networking traffic on UDP port 41641 for IPv6
# This enables Tailscale to work with both IPv4 and IPv6 networks
# IPv6 support ensures compatibility with modern networks and future-proofing
resource "google_compute_firewall" "tailscale-udp-ipv6" {
  name    = "tailscale-udp-ipv6"
  network = google_compute_network.vpc.name
  description = "UDP port for tailscale IPv6"

  # Allow UDP traffic on port 41641 (same port as IPv4)
  allow {
    protocol = "udp"
    ports    = [
      "41641", # Tailscale UDP port for mesh networking (IPv6)
    ]
  }

  # Only apply to instances tagged with "tailscale"
  target_tags = [ "tailscale" ]

  # Priority 999 allows this to override the default deny rule
  priority = 999

  # Allow from any IPv6 source (::/0 means all IPv6 addresses)
  # This enables Tailscale to work across IPv6 networks
  source_ranges = [
    "::/0" # All IPv6 addresses
  ]
}