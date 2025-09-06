# Tailscale GCP VM Setup Guide

This guide will help you set up a Tailscale machine on Google Cloud Platform (GCP) using Terraform. Don't worry if you're not very technical - this guide explains everything step by step!

## What is this project?

This project creates a virtual machine (VM) on Google Cloud that runs Tailscale. Think of it as creating your own private network that you can connect to from anywhere in the world, securely.

## What you'll need before starting

1. **A Google Cloud Platform account** - You'll need to sign up at [cloud.google.com](https://cloud.google.com)
2. **Terraform installed** - This is a tool that helps create cloud resources automatically
3. **Basic command line knowledge** - Don't worry, we'll guide you through each command

## Understanding the files

Let's break down what each file does:

### 📁 `main.tf` - The main configuration
This file tells Terraform:
- Which cloud provider to use (Google Cloud)
- To enable OS Login (a security feature that lets you log in using your Google account)

### 📁 `variables.tf` - Settings you can customize
This file defines two important settings you'll need to provide:
- **Project ID**: Your Google Cloud project's unique identifier
- **Region**: Which geographic location to create your VM in (like "us-central1")

### 📁 `compute.tf` - The virtual machine setup
This file creates:
- A **static IP address** for your VM (so it always has the same address)
- The **virtual machine itself** with:
  - Ubuntu 20.04 operating system
  - Small machine type (cost-effective)
  - IP forwarding enabled (needed for exit node functionality)
  - Proper network configuration

### 📁 `vpc.tf` - Network security and setup
This file creates:
- A **Virtual Private Cloud (VPC)** - Think of it as your own private network
- A **subnet** - A smaller network within your VPC
- **Firewall rules** that control what traffic can reach your VM:
  - Blocks all traffic by default (security first!)
  - Allows SSH connections (so you can manage the VM)
  - Allows Tailscale traffic on port 41641

### 📁 `dns.tf` - DNS configuration
This file sets up DNS forwarding, which helps with network name resolution.

## Step-by-step setup instructions

### Step 1: Install Terraform
1. Go to [terraform.io/downloads](https://terraform.io/downloads)
2. Download Terraform for your operating system
3. Follow the installation instructions for your system

### Step 2: Set up Google Cloud
1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create a new project or select an existing one
3. Note down your **Project ID** (you'll need this later)
4. Enable the following APIs:
   - Compute Engine API
   - Cloud DNS API

### Step 3: Set up authentication
1. Install the Google Cloud CLI: [cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)
2. Run this command in your terminal:
   ```bash
   gcloud auth application-default login
   ```
3. Follow the prompts to log in with your Google account

### Step 4: Prepare your Terraform configuration
1. Open the `variables.tf` file
2. You can either:
   - Set default values for the variables, or
   - Create a `values.auto.tfvars` file with your values

**Example `values.auto.tfvars` file:**
```hcl
project_id = "your-project-id-here"
region     = "us-central1"
```

### Step 5: Deploy your infrastructure
1. Open a terminal/command prompt
2. Navigate to the folder containing these files
3. Run these commands one by one:

   ```bash
   # Initialize Terraform
   terraform init
   
   # See what Terraform will create (optional but recommended)
   terraform plan
   
   # Create the resources
   terraform apply
   ```

4. When prompted, type `yes` to confirm the creation

### Step 6: Set up Tailscale on your VM
1. After Terraform finishes, you'll get the VM's IP address
2. Connect to your VM using SSH:
   ```bash
   gcloud compute ssh --zone "YOUR_REGION-a" "tailscale" --project "YOUR_PROJECT_ID" --tunnel-through-iap
   ```
3. Install Tailscale on the VM:
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   ```
4. Start Tailscale:
   ```bash
   sudo tailscale up
   ```
5. Follow the authentication process to connect to your Tailscale network

## Understanding the costs

- **VM**: The `e2-small` machine type costs approximately $10-12 per month
- **Static IP**: About $1.50 per month when the VM is running
- **Network traffic**: Minimal costs for typical usage
- **Total estimated cost**: $8-10 per month

## Security features included

1. **Default deny firewall**: Blocks all traffic by default
2. **SSH access**: Only allows SSH from Google's Identity-Aware Proxy
3. **Tailscale ports**: Only allows necessary Tailscale traffic
4. **OS Login**: Uses Google's secure authentication system

## Troubleshooting common issues

### "Project not found" error
- Make sure your Project ID is correct
- Ensure you have the necessary permissions in the project

### "API not enabled" error
- Go to Google Cloud Console → APIs & Services
- Enable Compute Engine API and Cloud DNS API

### Can't connect to the VM
- Check that the firewall rules are applied correctly
- Verify the VM is running in the Google Cloud Console

### Tailscale not working
- Make sure port 41641 is open (it should be from the Terraform configuration)
- Check that IP forwarding is enabled (it should be from the Terraform configuration)

## Cleaning up (when you're done)

To avoid ongoing charges, you can destroy everything you created:

```bash
terraform destroy
```

**Warning**: This will permanently delete your VM and all associated resources!

## Getting help

- **Terraform documentation**: [terraform.io/docs](https://terraform.io/docs)
- **Google Cloud documentation**: [cloud.google.com/docs](https://cloud.google.com/docs)
- **Tailscale documentation**: [tailscale.com/kb](https://tailscale.com/kb)

## What's next?

Once your Tailscale VM is running:
1. Install Tailscale on your devices (phone, laptop, etc.)
2. Connect them to your private network
3. Access your VM and other devices securely from anywhere
4. Consider setting up additional services on your VM

Remember: This creates a real VM that costs money, so make sure to destroy it when you're done experimenting!
