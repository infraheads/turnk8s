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
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13"
    }
  }
}