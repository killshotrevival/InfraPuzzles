# =============================================================================
# DNS Policy Configuration
# =============================================================================
# Creates a DNS policy for the VPC to enable DNS resolution within the network
# This allows VMs in the VPC to resolve DNS queries through Google's DNS infrastructure
resource "google_dns_policy" "tailscale-inbound-dns" {
  name                      = "tailscale-inbound-dns"
  # Enable inbound DNS forwarding: Allows VMs to receive DNS queries from external sources
  # This is useful for Tailscale nodes that may need to resolve external hostnames
  enable_inbound_forwarding = true
  description = "Expose DNS endpoints per subnet"
  # Disable DNS query logging to reduce costs and avoid storing sensitive query data
  enable_logging = false

  # Apply this DNS policy to our custom VPC
  # This ensures all VMs in the VPC use this DNS configuration
  networks {
    network_url = google_compute_network.vpc.name
  }
}