provider "proxmox" {
  pm_api_url          = local.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true
}

provider "github" {
  token = var.github_token
  owner = "infraheads"
}
