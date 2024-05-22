resource "proxmox_vm_qemu" "controlplane" {
  name        = "${local.input_vars.cluster_name}-cp"
  target_node = local.proxmox_target_node
  iso         = local.talos_iso

  cores   = local.input_vars.controlplane.cpu_cores
  sockets = var.controlplane_sockets
  cpu     = var.controlplane_cpu

  qemu_os = var.controlplane_qemu_os
  scsihw  = var.controlplane_scsihw
  memory  = local.input_vars.controlplane.memory
  agent   = 1

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.controlplane_disk_storage
          size     = local.input_vars.controlplane.disk_size
          iothread = true
          asyncio  = "native"
        }
      }
    }
  }

  network {
    bridge   = var.controlplane_network_bridge
    model    = var.controlplane_network_model
    firewall = var.controlplane_network_firewall
  }
}
