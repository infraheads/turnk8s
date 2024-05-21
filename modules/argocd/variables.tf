variable "git_repository_ssh_url" {
  description = "Git repository ssh url contains for workload"
  type        = string
  default     = "git@github.com:example/project.git"
}

variable "registry" {
  description = "The registry from which images will be downloaded"
  type        = string
}

# ArgoCD variables
variable "argocd_chart_name" {
  type    = string
  default = "argo-cd"
}

variable "argocd_chart_version" {
  type    = string
  default = "6.7.18"
}

variable "argocd_chart_repository" {
  type    = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_admin_password" {
  description = "Encrypted password for admin user"
  type        = string
}

# ArgoCD AppOfApps variables
variable "app_of_apps_chart_name" {
  type    = string
  default = "argocd-apps"
}

variable "app_of_apps_chart_version" {
  type    = string
  default = "1.6.2"
}

variable "app_of_apps_chart_repository" {
  type    = string
  default = "https://argoproj.github.io/argo-helm"
}
