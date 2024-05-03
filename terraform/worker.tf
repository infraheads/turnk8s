resource "random_integer" "wn_vm_id" {
  count = var.worker_nodes_count

  max = 999999999
  min = 100000000
}

resource "proxmox_vm_qemu" "worker" {
  count = var.worker_nodes_count

  name        = "${var.cluster_name}-worker-${count.index}-${random_integer.wn_vm_id[count.index].result}"
  target_node = "pve01"
  iso         = local.talos_iso
  vmid        = random_integer.wn_vm_id[count.index].result

  cores   = var.worker_cores
  sockets = var.worker_sockets
  cpu     = var.worker_cpu

  qemu_os = var.worker_qemu_os
  scsihw  = var.worker_scsihw
  memory  = var.worker_memory

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.worker_disk_storage
          size     = var.worker_disk_size
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
