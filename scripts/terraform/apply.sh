#!/bin/bash


type=$1
clusters=( "${@:2}" )

for cluster in "${clusters[@]}"
do
  export TF_VAR_cluster_name="$cluster"
  workspace="${cluster#turnk8s-}-$type"
  terraform workspace select -or-create "$workspace"
  terraform validate -no-color
  terraform plan -out="tfplan-$workspace"
  terraform apply "tfplan-$workspace"
done