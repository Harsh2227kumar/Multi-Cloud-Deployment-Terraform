resource "google_compute_instance" "gcp_vm" {
  name         = "gcp-ubuntu-vm"
  machine_type = "e2-micro"
  zone         = "${var.gcp_region}-a"
  project      = var.gcp_project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.module}/../ssh-keys/id_ed25519.pub")}"
  }

  metadata_startup_script = <<-SCRIPT
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
    user        = "ubuntu"
    private_key = file("${path.module}/../ssh-keys/id_ed25519")
    host        = self.network_interface[0].access_config[0].nat_ip
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
