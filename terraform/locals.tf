locals {
  proxmox_api_url      = "https://${local.input_vars.host_ip}:8006/api2/json"
  proxmox_ssh_key_path = "~/.ssh/proxmox_key"
  proxmox_target_node  = local.input_vars.host_ip == "192.168.1.5" ? "pve01" : "pve02"

  input_vars = yamldecode(file("../inputs.yaml"))

  ip_filename = "/tmp/${local.input_vars.cluster_name}_vms_ip.txt"
  talos_iso   = "local:iso/metal-amd64-${local.input_vars.versions.talos}.iso"

  cp_ip = try(
    [
      for line in split("\n", data.local_file.vm_ips.content) :
      split(" ", line)[1] if split(" ", line)[0] == tostring(proxmox_vm_qemu.controlplane.vmid)
    ][0],
    null
  )
}