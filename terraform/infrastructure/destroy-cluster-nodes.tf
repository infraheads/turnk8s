resource "terraform_data" "delete_nodes" {
  depends_on = [terraform_data.kubeconfig]

  # Ensure to delete worker nodes when cluster is scaled down
  triggers_replace = [
    length(local.workers)
  ]

  provisioner "local-exec" {
    command = "bash ../../scripts/bash/destroy_cluster_nodes.sh ${var.cluster_name} ${length(local.workers)}"
  }
}