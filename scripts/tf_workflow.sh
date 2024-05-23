#!/bin/bash

# Fetch clusters
clusters=$(yq e '[.[].cluster_name]' inputs.yaml | jq -r '.[]' | paste -sd "," -)

# Fetch workspaces, ensuring it is a comma-separated list
workspaces=$(terraform workspace list | awk '!/^\s*$/ {gsub(/\*/, ""); if ($1 != "default-ws") printf "%s, ", $1}' | sed 's/, $//' | sed 's/,  \+/, /g')

# Convert comma-separated lists to arrays
IFS=',' read -r -a cluster_array <<< "$clusters"
IFS=',' read -r -a workspace_array <<< "$workspaces"

# Use associative arrays to find elements in workspaces not in clusters
declare -A cluster_map
for cluster in "${cluster_array[@]}"; do
    cluster_map["$cluster"]=1
done

# Check each workspace to see if it's in the cluster map
for workspace in "${workspace_array[@]}"; do
    if [[ -z ${cluster_map[$workspace]} ]]; then
        echo "$workspace"
    fi
done
