resource "random_integer" "wn_vm_id" {
  count = local.input_vars.worker.nodes_count

  max = 999999999
  min = 100000000
}

resource "proxmox_vm_qemu" "worker" {
  count = local.input_vars.worker.nodes_count

  name        = "${local.input_vars.cluster_name}-worker-${count.index}-${random_integer.wn_vm_id[count.index].result}"
  target_node = "pve01"
  iso         = local.talos_iso
  vmid        = random_integer.wn_vm_id[count.index].result

  cores   = local.input_vars.worker.cpu_cores
  sockets = var.worker_sockets
  cpu     = var.worker_cpu

  qemu_os = var.worker_qemu_os
  scsihw  = var.worker_scsihw
  memory  = local.input_vars.worker.memory

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.worker_disk_storage
          size     = local.input_vars.worker.disc_size
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
