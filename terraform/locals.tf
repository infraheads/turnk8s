locals {
  proxmox_api_url      = "https://${var.proxmox_ip}:8006/api2/json"
  proxmox_ssh_key_path = "~/.ssh/proxmox_key"
  ip_filename          = "/tmp/${var.cluster_name}_vms_ip.txt"

  cp_ip = try(
    [
      for line in split("\n", data.local_file.vm_ips.content):
        split(" ", line)[1] if split(" ", line)[0] == tostring(proxmox_vm_qemu.controlplane.vmid)
    ][0],
    null
  )
}