terraform {
  required_version = ">= 1.7"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "infraheads"

    workspaces {
      prefix = "talos-proxmox-"
    }
  }

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }

  # ##  Used for end-to-end testing on project; update to suit your needs
  # backend "s3" {
  #   bucket = "terraform-ssp-github-actions-state"
  #   region = "us-west-2"
  #   key    = "e2e/ipv4-prefix-delegation/terraform.tfstate"
  # }
}