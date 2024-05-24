apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: infraheads
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default # each application belongs to a single project. if unspecified, an application belongs to the "default" projects

  source:
    repoURL: ${sourceRepoURL}
    targetRevision: main
    path: kubernetes
  destination:
    server: https://kubernetes.default.svc # endpoint of Kubernetes API Server
    namespace: default

  syncPolicy:
    automated:
      selfHeal: true # by default, changes made to the live cluster will not trigger automated sync (override manual changes on cluster)
      prune: true # by default, automatic sync will not delete resources