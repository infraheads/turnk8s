locals {
  proxmox_api_url     = "https://${var.proxmox_ip}:8006/api2/json"
  proxmox_target_node = var.proxmox_ip == "192.168.1.5" ? "pve01" : "pve02"

  clusters  = try({ tostring(var.cluster_name) = yamldecode(file(var.config_file_path))[var.cluster_name] }, {})
  talos_iso = "local:iso/metal-amd64-qemu-${var.talos_version}.iso"
}
