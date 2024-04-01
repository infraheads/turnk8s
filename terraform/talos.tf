# Generates machine secrets for Talos cluster
resource "talos_machine_secrets" "talos_secrets" {
  talos_version = local.talos_version
}

# Generates a machine configuration for the control plane (controlplane.yaml)
data "talos_machine_configuration" "cp_mc" {
  cluster_name       = "cp-${random_integer.cp_vm_id.result}"
  machine_type       = "controlplane"
  cluster_endpoint   = "https://${data.local_file.cp_ip.content}:6443"
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = local.kubernetes_version
  talos_version      = local.talos_version
}

# Generates client configuration for a Talos cluster (talosconfig)
data "talos_client_configuration" "cp_cc" {
  depends_on           = [data.local_file.cp_ip]
  cluster_name         = "cp-${random_integer.cp_vm_id.result}"
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  nodes                = [data.local_file.cp_ip.content]
  endpoints            = [data.local_file.cp_ip.content]
}

# Applies machine configuration to the control plane
resource "talos_machine_configuration_apply" "cp_mca" {
  depends_on = [
    proxmox_vm_qemu.controlplane
  ]
  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.cp_mc.machine_configuration
  node                        = data.local_file.cp_ip.content

#  lifecycle {
#    ignore_changes = [
#      machine_configuration_input
#    ]
#  }
}

# Bootstraps the etcd cluster on the control plane
resource "talos_machine_bootstrap" "cp_mb" {
  depends_on = [
    talos_machine_configuration_apply.cp_mca
  ]
  node                 = data.local_file.cp_ip.content
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration

}

# Retrieves the kubeconfig for a Talos cluster
data "talos_cluster_kubeconfig" "cp_ck" {
  depends_on = [
    talos_machine_bootstrap.cp_mb
  ]
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  node                 = data.local_file.cp_ip.content
}

# Generates a machine configuration for the worker (worker.yaml)
data "talos_machine_configuration" "worker_mc" {
  cluster_name       = "worker-${random_integer.wn_vm_id.result}"
  machine_type       = "worker"
  cluster_endpoint   = "https://${data.local_file.cp_ip.content}:6443"
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = local.kubernetes_version
  talos_version      = local.talos_version
}

# Applies machine configuration to the worker node
resource "talos_machine_configuration_apply" "worker_mca" {
  depends_on = [
    proxmox_vm_qemu.worker
  ]
  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker_mc.machine_configuration
  node                        = data.local_file.wn_ip.content

  lifecycle {
    ignore_changes = [
      machine_configuration_input
    ]
  }
}
