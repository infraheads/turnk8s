resource "helm_release" "netris-operator" {

  name             = "netris-operator"
  namespace        = "netris-operator"
  chart            = "netris-operator"
  version          = "2.0.0"
  repository       = "https://netrisai.github.io/charts"
  create_namespace = true
  recreate_pods    = true
  force_update     = true

  set {
    name  = "controller.host"
    value = var.netris_controller_host
  }

  set {
    name  = "controller.login"
    value = var.netris_controller_login
  }

  set {
    name  = "controller.password"
    value = var.netris_controller_password
  }

  set {
    name  = "controller.insecure"
    value = false
  }

  set {
    name  = "image.repository"
    value = "${var.image_registry}/netris-operator"
  }

  set {
    name  = "image.tag"
    value = "v3.0.0"
  }
}