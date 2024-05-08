resource "random_integer" "cp_vm_id" {
  max = 999999999
  min = 100000000
}

resource "proxmox_vm_qemu" "controlplane" {
  name        = "${local.input_vars.cluster_name}-cp-${random_integer.cp_vm_id.result}"
  target_node = "pve01"
  iso         = local.talos_iso
  vmid        = random_integer.cp_vm_id.result

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
