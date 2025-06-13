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
- Connected via SSH using Terraform’s `connection` block and `remote-exec`.
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