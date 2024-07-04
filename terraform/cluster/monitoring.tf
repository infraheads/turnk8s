resource "kubernetes_namespace" "monitoring" {
  depends_on = [kubernetes_manifest.local-path-provisioner]

  metadata {
    name = "monitoring"
    labels = {
      "pod-security.kubernetes.io/enforce": "privileged"
    }
  }
}

resource "helm_release" "prometheus" {
  depends_on = [kubernetes_namespace.monitoring]

  name             = var.prometheus_chart_name
  namespace        = "monitoring"
  chart            = var.prometheus_chart_name
  version          = var.prometheus_chart_version
  repository       = var.prometheus_chart_repository

  values = [
    templatefile("${path.module}/templates/monitoring.yaml.tpl",
      {
        registry      = var.image_registry,
        storage-class = kubernetes_manifest.local-path-provisioner[6].manifest.metadata.name,
      }
    )
  ]
}