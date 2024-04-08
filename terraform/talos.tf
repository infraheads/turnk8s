# Generates machine secrets for Talos cluster
resource "talos_machine_secrets" "talos_secrets" {
  talos_version = local.talos_version
}

# Generates a machine configuration for the control plane (controlplane.yaml)
data "talos_machine_configuration" "cp_mc" {
  cluster_name       = "${var.cluster_name}-cp-${random_integer.cp_vm_id.result}"
  machine_type       = "controlplane"
  cluster_endpoint   = "https://${local.cp_ip}:6443"
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = local.kubernetes_version
  talos_version      = local.talos_version
}

# Generates client configuration for a Talos cluster (talosconfig)
data "talos_client_configuration" "cp_cc" {
  depends_on           = [local.cp_ip]
  cluster_name         = data.talos_machine_configuration.cp_mc.cluster_name
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  nodes                = [local.cp_ip]
  endpoints            = [local.cp_ip]
}

# Applies machine configuration to the control plane
resource "talos_machine_configuration_apply" "cp_mca" {
  depends_on = [
    proxmox_vm_qemu.controlplane
  ]
  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.cp_mc.machine_configuration
  node                        = local.cp_ip
}

# Bootstraps the etcd cluster on the control plane
resource "talos_machine_bootstrap" "cp_mb" {
  depends_on = [
    talos_machine_configuration_apply.cp_mca
  ]
  node                 = local.cp_ip
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration

}

# Retrieves the kubeconfig for a Talos cluster
data "talos_cluster_kubeconfig" "cp_ck" {
  depends_on = [
    talos_machine_bootstrap.cp_mb
  ]
  client_configuration = talos_machine_secrets.talos_secrets.client_configuration
  node                 = local.cp_ip
}

# Generates a machine configuration for the worker (worker.yaml)
data "talos_machine_configuration" "worker_mc" {
  count = var.worker_nodes_count

  cluster_name       = "${var.cluster_name}-worker-${count.index}-${random_integer.wn_vm_id[count.index].result}"
  machine_type       = "worker"
  cluster_endpoint   = data.talos_machine_configuration.cp_mc.cluster_endpoint
  machine_secrets    = talos_machine_secrets.talos_secrets.machine_secrets
  kubernetes_version = local.kubernetes_version
  talos_version      = local.talos_version
}

# Applies machine configuration to the worker node
resource "talos_machine_configuration_apply" "worker_mca" {
  count      = var.worker_nodes_count
  depends_on = [
    proxmox_vm_qemu.worker
  ]

  client_configuration        = talos_machine_secrets.talos_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker_mc[count.index].machine_configuration
  node                        = try(
    [
      for line in split("\n", data.local_file.vm_ips.content):
        split(" ", line)[1] if length(split(" ", line)) > 1 && split(" ", line)[0] == tostring(random_integer.wn_vm_id[count.index].result)
    ][0],
    null
  )
}
