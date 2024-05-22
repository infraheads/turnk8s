# Generates machine secrets for Talos cluster
resource "talos_machine_secrets" "talos_secrets" {
  talos_version = local.input_vars.versions.talos
}

# Generates a machine configuration for the control plane (controlplane.yaml)
data "talos_machine_configuration" "cp_mc" {
  cluster_name       = proxmox_vm_qemu.controlplane.name
  machine_type       = "controlplane"
  cluster_endpoint   = "https://${proxmox_vm_qemu.controlplane.default_ipv4_address}:6443"
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = local.input_vars.versions.k8s
  talos_version      = local.input_vars.versions.talos
  config_patches     = [
    templatefile("${path.module}/templates/controlplane.yaml.tpl",
      {
        talos-version      = local.input_vars.versions.talos,
        kubernetes-version = local.input_vars.versions.k8s,
        registry           = var.image_registry
      }
    )
  ]
}

# Generates client configuration for a Talos cluster (talosconfig)
data "talos_client_configuration" "cp_cc" {
  depends_on           = [proxmox_vm_qemu.controlplane]
  cluster_name         = data.talos_machine_configuration.cp_mc.cluster_name
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  nodes                = [proxmox_vm_qemu.controlplane.default_ipv4_address]
  endpoints            = [proxmox_vm_qemu.controlplane.default_ipv4_address]
}

# Applies machine configuration to the control plane
resource "talos_machine_configuration_apply" "cp_mca" {
  depends_on = [
    proxmox_vm_qemu.controlplane
  ]
  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.cp_mc.machine_configuration
  node                        = proxmox_vm_qemu.controlplane.default_ipv4_address
}

# Bootstraps the etcd cluster on the control plane
resource "talos_machine_bootstrap" "cp_mb" {
  depends_on = [
    talos_machine_configuration_apply.cp_mca
  ]
  node                 = proxmox_vm_qemu.controlplane.default_ipv4_address
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration

}

# Retrieves the kubeconfig for a Talos cluster
data "talos_cluster_kubeconfig" "cp_ck" {
  depends_on = [
    talos_machine_bootstrap.cp_mb
  ]
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  node                 = proxmox_vm_qemu.controlplane.default_ipv4_address
}

# Generates a machine configuration for the worker (worker.yaml)
data "talos_machine_configuration" "worker_mc" {
  count = local.input_vars.worker_node.count

  cluster_name       = proxmox_vm_qemu.worker[count.index].name
  machine_type       = "worker"
  cluster_endpoint   = data.talos_machine_configuration.cp_mc.cluster_endpoint
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = local.input_vars.versions.k8s
  talos_version      = local.input_vars.versions.talos
  config_patches     = [
    templatefile("${path.module}/templates/worker.yaml.tpl",
      {
        talos-version      = local.input_vars.versions.talos,
        kubernetes-version = local.input_vars.versions.k8s,
        registry           = var.image_registry
      }
    )
  ]
}

# Applies machine configuration to the worker node
resource "talos_machine_configuration_apply" "worker_mca" {
  count      = local.input_vars.worker_node.count
  depends_on = [
    proxmox_vm_qemu.worker
  ]

  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker_mc[count.index].machine_configuration
  node                        = proxmox_vm_qemu.worker[count.index].default_ipv4_address
}

data "talos_cluster_health" "cluster_health" {
  depends_on           = [data.talos_cluster_kubeconfig.cp_ck]
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  control_plane_nodes  = [proxmox_vm_qemu.controlplane.default_ipv4_address]
  worker_nodes         = proxmox_vm_qemu.worker.*.default_ipv4_address
  endpoints            = [proxmox_vm_qemu.controlplane.default_ipv4_address]
  timeouts = {
    read = "1h"
  }
}


