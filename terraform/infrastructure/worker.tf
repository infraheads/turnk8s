resource "proxmox_vm_qemu" "worker" {
  for_each = local.clusters

  name        = "${var.cluster_name}-worker-index"
  target_node = local.proxmox_target_node
  iso         = local.talos_iso

  cores   = each.value.worker_node.cpu_cores
  sockets = var.worker_sockets
  cpu     = var.worker_cpu

  qemu_os = var.worker_qemu_os
  scsihw  = var.worker_scsihw
  memory  = each.value.worker_node.memory
  agent   = 1

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.worker_disk_storage
          size     = each.value.worker_node.disc_size
          iothread = true
          asyncio  = "native"
        }
      }
    }
  }

  network {
    bridge   = var.worker_network_bridge
    model    = var.worker_network_model
    firewall = var.worker_network_firewall
  }
}
