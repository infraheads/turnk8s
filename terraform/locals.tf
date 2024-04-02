locals {
  proxmox_api_url = "https://${var.proxmox_ip}:8006/api2/json"
  proxmox_ssh_key_path = "~/.ssh/proxmox_key"
  cp_ip_filename = "cp_ip.txt"
  wn_ip_filename = "wn_ip.txt"

  talos_version = "v1.6.7"
  kubernetes_version = "v1.29.3"
}