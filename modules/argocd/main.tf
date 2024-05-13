resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  chart            = var.argocd_chart_name
  version          = var.argocd_chart_version
  repository       = var.argocd_chart_repository
  create_namespace = true
  recreate_pods    = true
  force_update     = true

  values = [file("${path.module}/argocd.yaml")]

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }
}

resource "helm_release" "argocd-apps" {
  depends_on = [helm_release.argocd]

  name       = "argocd-apps"
  namespace  = helm_release.argocd.namespace
  chart      = var.app_of_apps_chart_name
  version    = var.app_of_apps_chart_version
  repository = var.app_of_apps_chart_repository

  values = [file("${path.module}/app-of-apps.yaml")]

  set {
    name  = "applications[0].source.repoURL"
    value = var.git_repository_ssh_url
  }
}