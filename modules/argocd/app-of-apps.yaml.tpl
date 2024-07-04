applications:
  app-of-apps:
    namespace: argocd
    finalizers:
    - resources-finalizer.argocd.argoproj.io
    project: default
    source:
      repoURL: ${repoURL}
      targetRevision: HEAD
      path: argocd_applications
    destination:
      server: https://kubernetes.default.svc
      namespace: argocd
    syncPolicy:
      automated:
        prune: true
        selfHeal: true