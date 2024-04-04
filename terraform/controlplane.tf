resource "random_integer" "cp_vm_id" {
  max = 999999999
  min = 100
}

resource "proxmox_vm_qemu" "controlplane" {
  name        = "${var.cluster_name}-cp-${random_integer.cp_vm_id.result}"
  target_node = "pve01"
  iso         = var.controlplane_iso
  vmid        = random_integer.cp_vm_id.result

  cores   = var.controlplane_cores
  sockets = var.controlplane_sockets
  cpu     = var.controlplane_cpu

  qemu_os = var.controlplane_qemu_os
  scsihw  = var.controlplane_scsihw
  memory  = var.controlplane_memory

  disks {
    scsi {
      scsi0 {
        disk {
          storage  = var.controlplane_disk_storage
          size     = var.controlplane_disk_size
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

resource "null_resource" "controlplane" {
  depends_on = [proxmox_vm_qemu.controlplane]
  provisioner "local-exec" {
    command = "bash ../scripts/get_ip.sh ${local.proxmox_ssh_key_path} ${var.proxmox_ip} ${local.cp_ip_filename} ${join(" ", proxmox_vm_qemu.controlplane.*.vmid)}"
  }
}

data "local_file" "cp_ip" {
  depends_on = [null_resource.controlplane]
  filename   = local.cp_ip_filename
}