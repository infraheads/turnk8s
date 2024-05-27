locals {
  proxmox_api_url     = "https://${var.proxmox_ip}:8006/api2/json"
  proxmox_target_node = var.proxmox_ip == "192.168.1.5" ? "pve01" : "pve02"

  clusters  = try({ tostring(var.cluster_name) = yamldecode(file("../../config.yaml"))[var.cluster_name] }, {})
  talos_iso = "local:iso/metal-amd64-qemu-${var.talos_version}.iso"

  workers_count = try([
    for cluster_key, cluster in local.clusters :
      cluster.worker_node.count
  ][0], 0)

  worker = try([
    for cluster_key, cluster in local.clusters :
      {
        cpu_cores = cluster.worker_node.cpu_cores
        disc_size = cluster.worker_node.disc_size
        memory    = cluster.worker_node.memory
      }
  ][0], {})
}
