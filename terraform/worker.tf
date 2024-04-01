resource "random_integer" "wn_vm_id" {
  max = 999999999
  min = 100
}

resource "proxmox_vm_qemu" "worker" {
  name        = "worker"
  target_node = "pve01"
  iso         = var.worker_iso
  vmid        = random_integer.wn_vm_id.result

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

resource "null_resource" "worker" {
  depends_on = [proxmox_vm_qemu.worker]
  provisioner "local-exec" {
    command = "sh ../scripts/get_ip.sh ${var.ssh_key_path} ${var.proxmox_ip} ${proxmox_vm_qemu.worker.vmid} ${local.wn_ip_filename}"
  }
}

data "local_file" "wn_ip" {
  depends_on = [null_resource.worker]
  filename   = local.wn_ip_filename
}