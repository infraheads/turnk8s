resource "terraform_data" "kubeconfig" {
  depends_on = [data.talos_cluster_kubeconfig.cp_ck]
  for_each   = local.clusters

  # Ensure to retrieve kubeconfig when worker nodes count is changed
  triggers_replace = [
    length(local.workers)
  ]

  provisioner "local-exec" {
    command = "bash ../../scripts/bash/create_kubeconfig.sh \"${yamlencode(data.talos_cluster_kubeconfig.cp_ck[each.key].kubeconfig_raw)}\" ${var.cluster_name}"
  }
}