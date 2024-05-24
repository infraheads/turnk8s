output "cluster_kubeconfig" {
  value     = data.talos_cluster_kubeconfig.cp_ck
  sensitive = true
}

output "github_repo_url" {
  value = github_repository.argocd_applications[var.cluster_name].http_clone_url
}