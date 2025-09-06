# =============================================================================
# Static External IP Address
# =============================================================================
# Creates a reserved static external IP address for the Tailscale VM
# Static IPs don't change when the VM is restarted, ensuring consistent connectivity
resource "google_compute_address" "tailscale-ip" {
  name         = "tailscale-ip"
  # EXTERNAL means this IP is accessible from the internet
  address_type = "EXTERNAL"
  description = "IP that will be used by the tailscale VM"
  # PREMIUM tier provides better performance and global reach
  network_tier = "PREMIUM"
  region       = var.region
}

# =============================================================================
# Tailscale Virtual Machine Instance
# =============================================================================
# Creates a GCP Compute Engine instance that will run Tailscale
# This VM will act as a Tailscale node in the mesh network
resource "google_compute_instance" "tailscale" {
  name = "tailscale"
  # e2-small: 2 vCPUs, 2GB RAM - sufficient for Tailscale operations
  machine_type = "e2-small"
  # Deploy in zone-a of the specified region for high availability
  zone = "${var.region}-a"
  # Apply "tailscale" tag to enable firewall rules targeting this instance
  tags = [ "tailscale" ]

  # Enable Google Cloud Ops Agent for monitoring and logging
  # This provides system metrics, logs, and application performance monitoring
  labels =  {
    "goog-ops-agent-policy" = "v2-x86-template-1-4-0"
  }

  # Network configuration - connects the VM to our custom VPC
  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name
    # External access configuration using our reserved static IP
    access_config {
      nat_ip = google_compute_address.tailscale-ip.address
    }
  }

  # CRITICAL: Enable IP forwarding for Tailscale functionality
  # This allows the VM to accept and process packets destined for other IP addresses
  # Required for Tailscale to function as an exit node or relay traffic
  can_ip_forward = true

  # Boot disk configuration
  boot_disk {
    initialize_params {
      # Ubuntu 20.04 LTS - stable, well-supported OS for Tailscale
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20231130"
    }
  }
}