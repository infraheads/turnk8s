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

variable "k8s_version" {
  description = "K8s version to be used"
  type        = string
  default     = "v1.30.0"
}

variable "proxmox_ip" {
  description = "IP of the Proxmox server"
  type        = string
  default     = "192.168.1.5"
}

variable "proxmox_token_id" {
  description = "This is an API token you have previously created for a specific user."
  type        = string
  sensitive   = true
}

variable "proxmox_token_secret" {
  description = "This uuid is only available when the token was initially created."
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
  default     = "Test"
}

variable "controlplane_cores" {
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  type        = number
  default     = 2
}

variable "controlplane_sockets" {
  description = "The number of CPU sockets to allocate to the VM."
  type        = number
  default     = 1
}

variable "controlplane_cpu" {
  description = "The type of CPU to emulate in the Guest."
  type        = string
  default     = "x86-64-v2-AES"
}

variable "controlplane_qemu_os" {
  description = "The type of OS in the guest."
  type        = string
  default     = "l26"
}

variable "controlplane_scsihw" {
  description = "The SCSI controller to emulate."
  type        = string
  default     = "virtio-scsi-single"
}

variable "controlplane_memory" {
  description = "The amount of memory to allocate to the VM in Megabytes."
  type        = number
  default     = 4096
}

variable "controlplane_network_bridge" {
  description = "Bridge to which the network device should be attached."
  type        = string
  default     = "vmbr1"
}

variable "controlplane_network_model" {
  description = "Network Card Model"
  type        = string
  default     = "virtio"
}

variable "controlplane_network_firewall" {
  description = "Whether to enable the Proxmox firewall on this network device."
  type        = bool
  default     = false
}

variable "controlplane_disk_storage" {
  description = "The name of the storage pool on which to store the disk."
  type        = string
  default     = "local-lvm"
}

variable "controlplane_disk_size" {
  description = "The size of the created disk in Gigabytes."
  type        = number
  default     = 32
}

# Node variables
variable "worker_nodes_count" {
  description = "Count of the Worker Nodes."
  type        = number
  default     = 1
}

variable "worker_cores" {
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  type        = number
  default     = 2
}

variable "worker_sockets" {
  description = "The number of CPU sockets to allocate to the VM."
  type        = number
  default     = 1
}

variable "worker_cpu" {
  description = "The type of CPU to emulate in the Guest."
  type        = string
  default     = "x86-64-v2-AES"
}

variable "worker_qemu_os" {
  description = "The type of OS in the guest."
  type        = string
  default     = "l26"
}

variable "worker_scsihw" {
  description = "The SCSI controller to emulate."
  type        = string
  default     = "virtio-scsi-single"
}

variable "worker_memory" {
  description = "The amount of memory to allocate to the VM in Megabytes."
  type        = number
  default     = 4096
}

variable "worker_network_bridge" {
  description = "Bridge to which the network device should be attached."
  type        = string
  default     = "vmbr1"
}

variable "worker_network_model" {
  description = "Network Card Model"
  type        = string
  default     = "virtio"
}

variable "worker_network_firewall" {
  description = "Whether to enable the Proxmox firewall on this network device."
  type        = bool
  default     = false
}

variable "worker_disk_storage" {
  description = "The name of the storage pool on which to store the disk."
  type        = string
  default     = "local-lvm"
}

variable "worker_disk_size" {
  description = "The size of the created disk in Gigabytes."
  type        = number
  default     = 32
}

variable "github_token" {
  description = "Git repository token"
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
