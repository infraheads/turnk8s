# Generates machine secrets for Talos cluster
resource "talos_machine_secrets" "talos_secrets" {
  talos_version = var.talos_version
}

# Generates client configuration for a Talos cluster (talosconfig)
data "talos_client_configuration" "cp_cc" {
  for_each = local.clusters

  cluster_name         = each.key
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  nodes                = [proxmox_vm_qemu.controlplane[each.key].default_ipv4_address]
  endpoints            = [proxmox_vm_qemu.controlplane[each.key].default_ipv4_address]
}

# Generates a machine configuration for the control plane (controlplane.yaml)
data "talos_machine_configuration" "cp_mc" {
  for_each = local.clusters

  cluster_name       = data.talos_client_configuration.cp_cc[each.key].cluster_name
  machine_type       = "controlplane"
  cluster_endpoint   = "https://${proxmox_vm_qemu.controlplane[each.key].default_ipv4_address}:6443"
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = var.k8s_version
  talos_version      = var.talos_version
  config_patches     = [
    templatefile("${path.module}/templates/controlplane.yaml.tpl",
      {
        talos-version      = var.talos_version,
        kubernetes-version = var.k8s_version,
        registry           = var.image_registry
        node-name          = "${var.cluster_name}-cp"
      }
    )
  ]
}

# Applies machine configuration to the control plane
resource "talos_machine_configuration_apply" "cp_mca" {
  for_each = local.clusters

  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.cp_mc[each.key].machine_configuration
  node                        = proxmox_vm_qemu.controlplane[each.key].default_ipv4_address
}

# Bootstraps the etcd cluster on the control plane
resource "talos_machine_bootstrap" "cp_mb" {
  depends_on = [talos_machine_configuration_apply.cp_mca]
  for_each   = local.clusters

  node                 = proxmox_vm_qemu.controlplane[each.key].default_ipv4_address
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
}

# Retrieves the kubeconfig for a Talos cluster
data "talos_cluster_kubeconfig" "cp_ck" {
  depends_on = [talos_machine_bootstrap.cp_mb]
  for_each   = local.clusters

  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  node                 = proxmox_vm_qemu.controlplane[each.key].default_ipv4_address
}

# Generates a machine configuration for the worker (worker.yaml)
data "talos_machine_configuration" "worker_mc" {
  depends_on = [proxmox_vm_qemu.worker]
  for_each = local.clusters

  cluster_name       = data.talos_client_configuration.cp_cc[each.key].cluster_name
  machine_type       = "worker"
  cluster_endpoint   = data.talos_machine_configuration.cp_mc[each.key].cluster_endpoint
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = var.k8s_version
  talos_version      = var.talos_version
}

# Applies machine configuration to the worker node
resource "talos_machine_configuration_apply" "worker_mca" {
  depends_on = [data.talos_machine_configuration.worker_mc]
  for_each = { for idx, worker in local.workers : idx => worker }

  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker_mc[var.cluster_name].machine_configuration
  node                        = proxmox_vm_qemu.worker[each.key].default_ipv4_address

  config_patches = [
    templatefile("${path.module}/templates/worker.yaml.tpl",
      {
        talos-version      = var.talos_version,
        kubernetes-version = var.k8s_version,
        registry           = var.image_registry
        node-name = "${var.cluster_name}-wn-${each.key}"
      }
    )
  ]
}

data "talos_cluster_health" "cluster_health" {
  depends_on           = [data.talos_cluster_kubeconfig.cp_ck]

  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  control_plane_nodes  = [for controlplane in proxmox_vm_qemu.controlplane : controlplane.default_ipv4_address]
  worker_nodes         = [for worker in proxmox_vm_qemu.worker : worker.default_ipv4_address]
  endpoints            = [for controlplane in proxmox_vm_qemu.controlplane : controlplane.default_ipv4_address]
  timeouts = {
    read = "1h"
  }
}