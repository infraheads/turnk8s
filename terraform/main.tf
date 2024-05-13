provider "proxmox" {
  pm_api_url          = local.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true

}

provider "random" {}

provider "kubernetes" {
  host = data.talos_cluster_kubeconfig.cp_ck.kubernetes_client_configuration.host

  client_certificate     = data.talos_cluster_kubeconfig.cp_ck.kubernetes_client_configuration.client_certificate
  client_key             = data.talos_cluster_kubeconfig.cp_ck.kubernetes_client_configuration.client_key
  cluster_ca_certificate = data.talos_cluster_kubeconfig.cp_ck.kubernetes_client_configuration.ca_certificate
}
