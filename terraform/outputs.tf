output "cp_ip" {
  value = data.local_file.cp_ip.content
}

output "wn_ip" {
  value = data.local_file.wn_ip.content
}

output "exporting_kubeconfig" {
  description = "export KUBECONFIG variable to connect Kubernetes locally."
  value       = <<-EOT
    export KUBECONFIG="/tmp/${proxmox_vm_qemu.controlplane.vmid}"
  EOT
}