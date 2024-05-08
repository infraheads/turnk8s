variable "talos_version" {
  description = "Talos version to be used"
  type = string
  default = "v1.7.1"
}

variable "talos_images_registry" {
  description = "The registry from which images should be downloaded for cluster"
  type = string
  default = "http://192.168.2.52:6000"
}

variable "k8s_version" {
  description = "K8s version to be used"
  type = string
  default = "v1.30.0"
}

variable "proxmox_ip" {
  description = "IP of the Proxmox server"
  type = string
  default = "192.168.1.1"
}

variable "proxmox_token_id" {
  description = "This is an API token you have previously created for a specific user."
  type = string
  nullable = false
}

variable "proxmox_token_secret" {
  description = "This uuid is only available when the token was initially created."
  type = string
  nullable = false
}

variable "cluster_name" {
  description = "The name of the cluster."
  type = string
  default = "Test"
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
  default     = true
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
  type = number
  default = 1
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
  default     = true
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

variable "git_private_ssh_key" {
  description = "SSH key path for git access"
  type        = string
}

variable "git_repository_ssh_url" {
  description = "Git repository ssh url contains for workload"
  type        = string
  default     = "git@github.com:hakobian4/microservices-demo-deployment.git"
}

variable "workloads_path" {
  description = "Workloads file location in git."
  type        = string
  default     = "bootstrap/workloads"
}

variable "argocd_ingress_hostname" {
  description = "Hostname for accessing to ArgoCD application."
  type = string
  default = "argocd.example.com"
}

variable "argocd_ingress_class_name" {
  type = string
  default = "nginx"
}
# ArgoCD variables
variable "argocd_chart_name" {
  type = string
  default = "argo-cd"
}

variable "argocd_chart_version" {
  type = string
  default = "6.6.0"
}

variable "argocd_chart_repository" {
  type = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_admin_password" {
  description = "Encrypted password for Argocd admin"
  type = string
}

# ArgoCD Apps variables
variable "argocd_app_of_apps_chart_name" {
  type = string
  default = "argocd-apps"
}

variable "argocd_app_of_apps_chart_version" {
  type = string
  default = "1.6.2"
}

variable "argocd_app_of_apps_chart_repository" {
  type = string
  default = "https://argoproj.github.io/argo-helm"
}