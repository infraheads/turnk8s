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
    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13"
    }
  }

  # ##  Used for end-to-end testing on project; update to suit your needs
  # backend "s3" {
  #   bucket = "terraform-ssp-github-actions-state"
  #   region = "us-west-2"
  #   key    = "e2e/ipv4-prefix-delegation/terraform.tfstate"
  # }
}