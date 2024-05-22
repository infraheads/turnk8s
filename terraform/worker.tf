resource "proxmox_vm_qemu" "worker" {
  count = local.input_vars.worker_node.count

  name        = "${local.input_vars.cluster_name}-worker-${count.index}"
  target_node = local.proxmox_target_node
  iso         = local.talos_iso

  cores   = local.input_vars.worker_node.cpu_cores
  sockets = var.worker_sockets
  cpu     = var.worker_cpu

  qemu_os = var.worker_qemu_os
  scsihw  = var.worker_scsihw
  memory  = local.input_vars.worker_node.memory
  agent   = 1

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.worker_disk_storage
          size     = local.input_vars.worker_node.disc_size
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
