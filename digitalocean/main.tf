terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

# Create new SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "taskease-key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  public_key = file("${path.module}/../ssh-keys/id_ed25519.pub")
}

resource "digitalocean_droplet" "do_vm" {
  name   = "do-ubuntu-vm"
  region = "blr1"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"

  ssh_keys = [digitalocean_ssh_key.default.id]
  user_data = <<-SCRIPT
    #!/bin/bash
    set -e
    echo "Starting server setup..."
    
    # Update system
    sudo apt-get update
    sudo apt-get upgrade -y
    
    # Remove any existing nginx
    sudo apt-get remove -y nginx nginx-common nginx-full
    sudo apt-get autoremove -y
    
    # Install nginx
    sudo apt-get install -y nginx
    
    # Create web directory with proper permissions
    sudo mkdir -p /var/www/html
    sudo chown -R www-data:www-data /var/www/html
    
    # Start and enable nginx
    sudo systemctl daemon-reload
    sudo systemctl enable nginx
    sudo systemctl start nginx
    
    # Wait for nginx to be fully started
    while ! sudo systemctl is-active --quiet nginx; do
      sleep 5
    done
    
    # Create a test file to verify nginx is working
    echo "<html><body><h1>Nginx is working!</h1></body></html>" | sudo tee /var/www/html/index.html
    sudo chown www-data:www-data /var/www/html/index.html
  SCRIPT

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${path.module}/../ssh-keys/id_ed25519")
    host        = self.ipv4_address
  }

  provisioner "file" {
    source      = "${path.module}/../Html/index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo mkdir -p /var/www/html",
      "sudo chown www-data:www-data /tmp/index.html",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo chown www-data:www-data /var/www/html/index.html",
      "sudo systemctl restart nginx"
    ]
  }
}
