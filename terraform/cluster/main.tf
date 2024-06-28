provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.infrastructure.outputs.cluster_kubeconfig[var.cluster_name].kubernetes_client_configuration.host
    client_certificate     = base64decode(data.terraform_remote_state.infrastructure.outputs.cluster_kubeconfig[var.cluster_name].kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(data.terraform_remote_state.infrastructure.outputs.cluster_kubeconfig[var.cluster_name].kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infrastructure.outputs.cluster_kubeconfig[var.cluster_name].kubernetes_client_configuration.ca_certificate)
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = "infraheads"
    workspaces = {
      name = "turnk8s-${ startswith(var.cluster_name, "turnk8s-") ? substr(var.cluster_name, 8, -1) : var.cluster_name }-infrastructure"
    }
  }
}