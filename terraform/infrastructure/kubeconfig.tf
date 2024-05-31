resource "terraform_data" "kubeconfig" {
  depends_on = [data.talos_cluster_kubeconfig.cp_ck]
  for_each   = local.clusters

  provisioner "local-exec" {
    command = "sh ../../scripts/create_kubeconfig.sh \"${yamlencode(data.talos_cluster_kubeconfig.cp_ck[each.key].kubeconfig_raw)}\" ${var.secondary_cluster_name}"
  }
}