variable "cluster_name" {
  description = "The name of the cluster."
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
  default = "6.7.18"
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
  default = "1.6.2"
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

# Monitoring Configuration
variable "prometheus_chart_name" {
  type = string
  default = "kube-prometheus-stack"
}

variable "prometheus_chart_version" {
  type = string
  default = "60.5.0"
}

variable "prometheus_chart_repository" {
  type = string
  default = "https://prometheus-community.github.io/helm-charts"
}
