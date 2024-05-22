locals {
  proxmox_api_url      = "https://${var.proxmox_ip}:8006/api2/json"
  proxmox_ssh_key_path = "~/.ssh/proxmox_key"
  proxmox_target_node  = var.proxmox_ip == "192.168.1.5" ? "pve01" : "pve02"

  input_vars = [for cluster in yamldecode(file("../inputs.yaml")) : cluster if cluster.cluster_name == terraform.workspace][0]
  talos_iso     = "local:iso/metal-amd64-qemu-${local.input_vars.versions.talos}.iso"
}