variable "cluster_name" {
  description = "The cluster name exists in config file."
  type        = string
  default     = "turnk8s-cluster"
}

variable "talos_version" {
  description = "Talos version to be used"
  type        = string
  default     = "v1.7.1"
}

variable "image_registry" {
  description = "The registry from which images should be downloaded for cluster"
  type        = string
  default     = "192.168.2.4:6000"
}

# ArgoCD variables
variable "argocd_chart_name" {
  type    = string
  default = "argo-cd"
}

variable "argocd_chart_version" {
  type    = string
  default = "7.3.4"
}

variable "argocd_chart_repository" {
  type    = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_admin_password" {
  description = "Encrypted password for Argocd admin"
  type        = string
}

# ArgoCD Apps variables
variable "argocd_app_of_apps_chart_name" {
  type    = string
  default = "argocd-apps"
}

variable "argocd_app_of_apps_chart_version" {
  type    = string
  default = "2.0.0"
}

variable "argocd_app_of_apps_chart_repository" {
  type    = string
  default = "https://argoproj.github.io/argo-helm"
}

# Netris Configuration
variable "netris_controller_host" {
  description = "Netris controller host."
  type        = string
}

variable "netris_controller_login" {
  description = "Netris controller login"
  type        = string
  sensitive   = true
}

variable "netris_controller_password" {
  description = "Netris controller password"
  type        = string
  sensitive   = true
}
