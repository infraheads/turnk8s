resource "github_repository" "argocd_applications" {
  depends_on = [proxmox_vm_qemu.controlplane, proxmox_vm_qemu.worker]
  for_each   = local.clusters

  name        = var.cluster_name
  description = "This repo is for the ArgoCD Applications."

  template {
    owner                = "infraheads"
    repository           = "turnk8s_template_repo"
    include_all_branches = true
  }
}

resource "github_repository_file" "argocd_application" {
  for_each   = local.clusters

  repository = github_repository.argocd_applications[each.key].name
  branch     = "main"
  file       = "argocd_applications/infraheads.yaml"
  content    = templatefile("${path.module}/templates/argocd_application.yaml.tpl",
    {
      sourceRepoURL = github_repository.argocd_applications[each.key].http_clone_url
    }
  )
}