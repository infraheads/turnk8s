terraform {
  required_version = ">= 1.7"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "infraheads"

    workspaces {
      prefix = "turnk8s-"
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
  }
}