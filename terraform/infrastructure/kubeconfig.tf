resource "terraform_data" "kubeconfig" {
  depends_on = [data.talos_cluster_kubeconfig.cp_ck]

  provisioner "local-exec" {
    command = "sh ../../scripts/create_kubeconfig.sh \"${yamlencode(data.talos_cluster_kubeconfig.cp_ck.kubeconfig_raw)}\" ${var.cluster_name}"
  }
}