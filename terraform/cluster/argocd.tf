module "argocd" {

  source     = "../../modules/argocd"

  git_repository_ssh_url = data.terraform_remote_state.infrastructure.outputs.github_repo_url[var.cluster_name].http_clone_url
  registry               = var.image_registry

  argocd_chart_name         = var.argocd_chart_name
  argocd_chart_version      = var.argocd_chart_version
  argocd_chart_repository   = var.argocd_chart_repository
  argocd_admin_password     = var.argocd_admin_password

  app_of_apps_chart_name       = var.argocd_app_of_apps_chart_name
  app_of_apps_chart_version    = var.argocd_app_of_apps_chart_version
  app_of_apps_chart_repository = var.argocd_app_of_apps_chart_repository
}