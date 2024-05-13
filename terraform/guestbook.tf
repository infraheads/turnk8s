resource "kubernetes_manifest" "guestbook" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      labels = {
        "app.kubernetes.io/managed-by" = "argocd"
        "app.kubernetes.io/name"       = "argocd"
      }
      name      = "guestbook"
      namespace = "argocd"
    }
    spec = {
      destination = {
        namespace = "default"
        server    = "https://kubernetes.default.svc"
      }
      ignoreDifferences = [
        {
          group = "argoproj.io"
          jsonPointers = [
            "/status",
          ]
          kind = "Application"
        },
      ]
      project = "default"
      source = {
        path    = "guestbook"
        repoURL = "https://github.com/argoproj/argocd-example-apps"
      }
      syncPolicy = {
        automated = {
          allowEmpty = true
          prune      = true
          selfHeal   = true
        }
      }
    }
  }
}
