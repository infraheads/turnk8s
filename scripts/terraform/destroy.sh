#!/bin/bash


clusters=( "$@" )

for cluster in "${clusters[@]}"
do
  export TF_VAR_cluster_name="$cluster"
  cluster_without_prefix="${cluster#turnk8s-}"
  terraform workspace select "$cluster_without_prefix-infrastructure"
  terraform destroy -auto-approve
  terraform workspace select "default-ws"
  terraform workspace delete -force "$cluster_without_prefix-infrastructure"
  terraform workspace delete -force "$cluster_without_prefix-cluster"
done