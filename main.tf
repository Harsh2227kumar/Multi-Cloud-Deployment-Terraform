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

provider "google" {
  credentials = file("gcp/service-account.json")
  project     = var.gcp_project_id
  region      = var.gcp_region
}

provider "digitalocean" {
  token = var.do_token
}

module "gcp" {
  source = "./gcp"
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
}

module "do" {
  source = "./digitalocean"
  do_token = var.do_token
}
