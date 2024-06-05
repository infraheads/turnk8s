resource "github_repository" "argocd_applications" {
  depends_on = [proxmox_vm_qemu.controlplane, proxmox_vm_qemu.worker]

  name                 = var.cluster_name
  description          = "This repo is for the ArgoCD Applications."
  vulnerability_alerts = true

  template {
    owner                = "infraheads"
    repository           = "turnk8s_template_repo"
    include_all_branches = false
  }
}

resource "github_repository_file" "argocd_application" {
  repository = github_repository.argocd_applications.name
  branch     = "main"
  file       = "argocd_applications/infraheads.yaml"
  content    = templatefile("${path.module}/templates/argocd_application.yaml.tpl",
    {
      sourceRepoURL = github_repository.argocd_applications.http_clone_url
    }
  )
}