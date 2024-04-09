locals {
  proxmox_api_url      = "https://${var.proxmox_ip}:8006/api2/json"
  proxmox_ssh_key_path = "~/.ssh/proxmox_key"
  ip_filename          = "${var.cluster_name}_vms_ip.txt"

  talos_version      = "v1.6.7"
  kubernetes_version = "v1.29.3"

  cp_ip = try(
    [
      for line in split("\n", data.local_file.vm_ips.content):
        split(" ", line)[1] if length(split(" ", line)) > 1 && split(" ", line)[0] == tostring(random_integer.cp_vm_id.result)
    ][0],
    null
  )
}