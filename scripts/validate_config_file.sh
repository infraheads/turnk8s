#!/bin/bash

# Path to the YAML file
FILE=$1

# Function to validate cluster
validate_cluster() {
  local cluster=$1

  controlplane_cpu=$(yq e ".$cluster.controlplane.cpu_cores" "$FILE")
  controlplane_memory=$(yq e ".$cluster.controlplane.memory" "$FILE")
  controlplane_disk=$(yq e ".$cluster.controlplane.disk_size" "$FILE")
  worker_node_count=$(yq e ".$cluster.worker_nodes.count" "$FILE")
  worker_node_cpu=$(yq e ".$cluster.worker_nodes.cpu_cores" "$FILE")
  worker_node_memory=$(yq e ".$cluster.worker_nodes.memory" "$FILE")
  worker_node_disk=$(yq e ".$cluster.worker_nodes.disk_size" "$FILE")

  # Validate CPU cores of the Control Plane
  if ! [[ "$controlplane_cpu" =~ ^(2|4|6|8)$ ]];
  then
    echo "Control Plane CPU cores must be one of the following values 2, 4, 6 or 8."
    exit 1
  fi

  # Validate RAM Memory of the Control Plane
  if ! [[ "$controlplane_memory" =~ ^(4096|6144|8192)$ ]];
  then
    echo "Control Plane Memory must be one of the following values 4096, 6144 or 8192."
    exit 1
  fi

  # Validate Disk size of the Control Plane
  if ! [[ "$controlplane_disk" =~ ^(10|20|40|60)$ ]];
  then
    echo "Control Plane Disk size must be one of the following values 10, 20, 40 or 60."
    exit 1
  fi

  # Validate the Worker Nodes count
  if ! [[ "$worker_node_count" =~ ^[1-5]$ ]];
  then
    echo "Worker Node count must be from 1 to 5 range."
    exit 1
  fi

  # Validate CPU cores of the Worker Node
  if ! [[ "$worker_node_cpu" =~ ^(2|4|6|8)$ ]];
  then
    echo "Worker Node CPU cores must be one of the following values 2, 4, 6 or 8."
    exit 1
  fi

  # Validate RAM Memory of the Worker Node
  if ! [[ "$worker_node_memory" =~ ^(2048|4096|6144)$ ]];
  then
    echo "Worker Node Memory must be one of the following values 2048, 4096 or 6144."
    exit 1
  fi

  # Validate Disk size of the Worker Node
  if ! [[ "$worker_node_disk" =~ ^(10|20|40|60)$ ]];
  then
    echo "Worker Node Disk size must be one of the following values 10, 20, 40 or 60."
    exit 1
  fi
}

# Checks if the YAML file is empty
if [[ $(yq e '.' "$FILE") ]];
then
  # Extract all clusters
  clusters=$(yq e 'keys | .[]' "$FILE")
  # Validate each cluster
  for cluster in $clusters; do
    validate_cluster "$cluster"
  done
fi