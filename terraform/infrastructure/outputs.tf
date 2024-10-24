output "cluster_kubeconfig" {
  value     = data.talos_cluster_kubeconfig.cp_ck
  sensitive = true
}

output "github_repo_url" {
  value = github_repository.argocd_applications
}

output "enable_monitoring" {
  value = try(local.clusters[var.cluster_name].monitoring, false)
}