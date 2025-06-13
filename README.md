# Multi-Cloud Infrastructure Project

## Project Overview
This project implements a multi-cloud infrastructure setup using Terraform, deploying web servers on both Google Cloud Platform (GCP) and DigitalOcean. The infrastructure includes automated server provisioning, nginx web server installation, and web content deployment.

## Project Structure
```
FirstProject/
├── .terraform/                  # Terraform working directory
├── .terraform.lock.hcl         # Terraform dependency lock file
├── digitalocean/               # DigitalOcean specific configurations
│   └── main.tf                 # DigitalOcean resource definitions
├── gcp/                        # GCP specific configurations
│   ├── main.tf                 # GCP resource definitions
│   └── variables.tf            # GCP module variables
├── Html/                       # Web content directory
│   └── index.html             # Web page content
├── scripts/                    # Server setup scripts
│   └── setup.sh               # Server initialization script
├── ssh-keys/                   # SSH key storage
│   ├── id_ed25519            # Private SSH key
│   └── id_ed25519.pub        # Public SSH key
├── main.tf                     # Root Terraform configuration
├── variables.tf                # Root variables definition
├── terraform.tfvars            # Variable values
├── terraform.tfstate           # Terraform state file
└── terraform.tfstate.backup    # Terraform state backup
```

## 🚀 What I Did

- Created an SSH key pair using `ssh-keygen` and saved in `ssh-keys/`.
- Wrote a `setup.sh` script to install NGINX using `sudo`.
- Configured Terraform providers for both **GCP** and **DigitalOcean**.
- Wrote a separate `main.tf` for each cloud that:
  - Provisions a **Ubuntu VM**
  - Installs **NGINX**
  - Uploads `Html/index.html`
  - Replaces `/var/www/html/index.html` using `sudo mv`
- Connected via SSH using Terraform’s `connection` block and `remote-exec`.
- Validated deployment by visiting the VM IPs in the browser.


## Infrastructure Components

### 1. Google Cloud Platform (GCP)
- **Instance Type**: e2-micro
- **Region**: us-central1-a
- **Image**: ubuntu-os-cloud/ubuntu-2204-lts
- **Services**:
  - Nginx web server
  - Custom web content deployment
  - Automated server setup

### 2. DigitalOcean
- **Droplet Type**: s-1vcpu-1gb
- **Region**: blr1 (Bangalore)
- **Image**: ubuntu-22-04-x64
- **Services**:
  - Nginx web server
  - Custom web content deployment
  - Automated server setup

## Configuration Details

### Provider Versions
```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
```

### Server Setup Script
Both cloud providers use a similar server setup script that:
1. Updates system packages
2. Removes existing nginx installations
3. Installs fresh nginx
4. Sets up proper directory permissions
5. Configures and starts nginx service
6. Deploys web content

### SSH Key Management
- Uses ED25519 SSH keys
- Keys stored in `ssh-keys/` directory
- Unique key names for DigitalOcean to prevent conflicts

## Security Features
1. SSH key-based authentication
2. Proper file permissions (www-data user)
3. Secure variable handling in terraform.tfvars
4. Sensitive data marked as sensitive in Terraform

## Deployment Process
1. Infrastructure initialization:
   ```bash
   terraform init
   ```
2. Plan deployment:
   ```bash
   terraform plan
   ```
3. Apply changes:
   ```bash
   terraform apply
   ```
4. Destroy infrastructure:
   ```bash
   terraform destroy
   ```

## Required Variables
- `do_token`: DigitalOcean API token
- `gcp_project_id`: GCP project identifier
- `gcp_region`: GCP region (default: us-central1)

## Best Practices Implemented
1. Modular Terraform configuration
2. Separate variable definitions
3. Proper error handling in scripts
4. Idempotent server setup
5. Secure credential management
6. Automated infrastructure deployment
7. Proper file permissions
8. Service health checks

## Maintenance Notes
1. State files should be backed up regularly
2. SSH keys should be rotated periodically
3. Terraform versions should be kept updated
4. Provider versions should be reviewed for updates

## Future Improvements
1. Add monitoring and logging
2. Implement backup strategies
3. Add load balancing
4. Implement CI/CD pipeline
5. Add more security measures
6. Implement auto-scaling
7. Add database integration
8. Implement SSL/TLS

## Troubleshooting
Common issues and solutions:
1. SSH key conflicts: Use unique key names
2. Nginx installation: Script includes proper error handling
3. File permissions: Proper ownership set for web files
4. Service startup: Includes health checks and retries

## Dependencies
- Terraform >= 1.0.0
- Google Cloud SDK
- DigitalOcean CLI (optional)
- SSH key pair
- Valid cloud provider credentials

# ✅ Task 2: Multi-Cloud Auto Deployment (GCP + DigitalOcean)

This task was part of my DevOps internship project, where I used **Terraform** to provision Ubuntu VMs in **GCP** and **DigitalOcean** simultaneously. On both VMs, I installed **NGINX** and replaced the default web page with my custom `index.html`.

---

## 🧰 Tools Used

- [Terraform](https://terraform.io)
- [Google Cloud Platform (GCP)](https://console.cloud.google.com/)
- [DigitalOcean](https://cloud.digitalocean.com/)
- [NGINX](https://nginx.org/)
- Git Bash / PowerShell (Windows)
- Local SSH keys
- Custom HTML file

---

## 📁 Folder Structure

```

FirstProject/
|   .terraform.lock.hcl
|   main.tf
|   README.md
|   terraform.tfstate
|   terraform.tfstate.backup
|   terraform.tfvars
|   variables.tf
|
+---.terraform
|  
|
+---digitalocean
|       main.tf
|
+---gcp
|       main.tf
|       service-account.json
|       variables.tf
|
+---Html
|       index.html
|
+---scripts
|       setup.sh
|
+---ssh-keys
|   |   id_ed25519
|   |   id_ed25519.pub
|   |
|   \---.qodo
\---taskease
        build.txt


```

## 🚀 What I Did

- Created an SSH key pair using `ssh-keygen` and saved in `ssh-keys/`.
- Wrote a `setup.sh` script to install NGINX using `sudo`.
- Configured Terraform providers for both **GCP** and **DigitalOcean**.
- Wrote a separate `main.tf` for each cloud that:
  - Provisions a **Ubuntu VM**
  - Installs **NGINX**
  - Uploads `Html/index.html`
  - Replaces `/var/www/html/index.html` using `sudo mv`
- Connected via SSH using Terraform's `connection` block and `remote-exec`.
- Validated deployment by visiting the VM IPs in the browser.

---

## 🧪 Commands I Ran

```bash
# Generate SSH keys
ssh-keygen -t ed25519 -C "multi-cloud" -f ssh-keys/id_ed25519

# Move to project directory
cd FirstProject/

# Initialize Terraform
terraform init

# Apply all resources (GCP + DigitalOcean) in one go
terraform apply -auto-approve
```

