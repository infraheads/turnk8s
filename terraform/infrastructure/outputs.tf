output "cluster_kubeconfig" {
  value     = data.talos_cluster_kubeconfig.cp_ck
  sensitive = true
}