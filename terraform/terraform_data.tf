resource "terraform_data" "vm_ips" {
  depends_on = [proxmox_vm_qemu.worker, proxmox_vm_qemu.controlplane]
  provisioner "local-exec" {
    command = "bash ../scripts/get_ip.sh ${local.proxmox_ssh_key_path} ${var.proxmox_ip} ${local.ip_filename} ${join(" ", proxmox_vm_qemu.controlplane.*.vmid)} ${join(" ", proxmox_vm_qemu.worker.*.vmid)}"
  }
}

data "local_file" "vm_ips" {
  depends_on = [terraform_data.vm_ips]
  filename   = local.ip_filename
}
