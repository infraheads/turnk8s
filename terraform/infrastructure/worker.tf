resource "proxmox_vm_qemu" "worker" {
  count = local.workers_count

  name        = "${var.cluster_name}-worker-${count.index}"
  target_node = local.proxmox_target_node
  iso         = local.talos_iso

  cores   = local.worker.cpu_cores
  sockets = var.worker_sockets
  cpu     = var.worker_cpu

  qemu_os = var.worker_qemu_os
  scsihw  = var.worker_scsihw
  memory  = local.worker.memory
  agent   = 1

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.worker_disk_storage
          size     = local.worker.disc_size
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
