output "exporting_kubeconfig" {
 description = "export KUBECONFIG variable to connect Kubernetes locally."
 value       = <<-EOT
   export KUBECONFIG="/tmp/${proxmox_vm_qemu.controlplane.vmid}"
 EOT
}