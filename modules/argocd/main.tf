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

  set {
    name  = "global.image.repository"
    value = "${var.registry}/argoproj/argocd"
  }

  set {
    name  = "dex.image.repository"
    value = "${var.registry}/dexidp/dex"
  }

  set {
    name  = "redis.image.repository"
    value = "${var.registry}/docker/library/redis"
  }
}

resource "helm_release" "argocd-apps" {
  depends_on = [helm_release.argocd]

  name       = "argocd-apps"
  namespace  = helm_release.argocd.namespace
  chart      = var.app_of_apps_chart_name
  version    = var.app_of_apps_chart_version
  repository = var.app_of_apps_chart_repository

  values = [
    templatefile("${path.module}/app-of-apps.yaml.tpl",
      {
        repoURL = var.git_repository_ssh_url
      }
    )
  ]
}