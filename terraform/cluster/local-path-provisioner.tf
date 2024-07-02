resource "kubernetes_namespace" "local-path-storage" {
  metadata {
    name = "local-path-storage"
    labels = {
      "pod-security.kubernetes.io/enforce": "privileged"
    }
  }
}

resource "kubernetes_manifest" "local-path-provisioner" {
  depends_on = [kubernetes_namespace.local-path-storage]
  for_each = { for key, manifest in split("---", file("${path.module}/templates/local-path-provisioner.yaml")) : key => manifest }
  manifest =  yamldecode(each.value)
}