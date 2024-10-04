#!/bin/bash

cluster_name=$1
desired_worker_nodes_count=$2
existing_worker_nodes_count=$(terraform state list | grep "proxmox_vm_qemu.worker" | wc -l)
removable_worker_nodes_count=$(expr "$existing_worker_nodes_count" - "$desired_worker_nodes_count")

if [ "$removable_worker_nodes_count" -gt 0 ]; then
  export KUBECONFIG="/opt/kubeconfig/$cluster_name"
  for (( i="$desired_worker_nodes_count"; i<"$existing_worker_nodes_count"; i++ ))
  do
    kubectl delete node "$cluster_name-wn-$i"
  done
fi