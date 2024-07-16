resource "proxmox_vm_qemu" "worker" {
  for_each = { for idx, worker in local.worker : idx => worker }

  name        = "${var.cluster_name}-worker-${each.key}"
  target_node = local.proxmox_target_node
  iso         = local.talos_iso

  cores   = each.value.cpu_cores
  sockets = var.worker_sockets
  cpu     = var.worker_cpu

  qemu_os = var.worker_qemu_os
  scsihw  = var.worker_scsihw
  memory  = each.value.memory
  agent   = 1

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.worker_disk_storage
          size     = each.value.disk_size
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
