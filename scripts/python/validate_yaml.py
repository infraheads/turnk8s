# This script checks config.yaml and test_config.yaml files validity.
import os
import sys
import yaml
import pathlib
import argparse

from typing import Optional
from schema import Schema, And, Use, Or, SchemaError


# Validate YAML empty lines
def check_empty_lines(yaml_content):

    # Check for empty lines
    lines = yaml_content.splitlines()
    empty_lines = [i + 1 for i in range(len(lines)) if not lines[i].strip()]

    if empty_lines:
        raise yaml.YAMLError(f"Empty lines found in YAML file at: {', '.join(map(str, empty_lines))} lines.")

    return True


# Custom validator for the cluster names
def validate_cluster_names(cluster_config: dict, cluster_name: Optional[str]):

    if not isinstance(cluster_config, dict):
        raise SchemaError(f"Cluster config contains unstructured lines.")

    if cluster_name:
        if cluster_name not in cluster_config:
            raise SchemaError(f"Cluster name must be match with \"turnk8s-<PR_NUMBER>\" format.")
        elif len(cluster_config) != 1:
            raise SchemaError(f"Only one cluster must be described within test_config.yaml file.")
    else:
        for cluster_name, cluster_info in cluster_config.items():
            if cluster_name.startswith("turnk8s-"):
                raise SchemaError(f"Cluster name {cluster_name} does not start with \"turnk8s-\" prefix.")

    return cluster_config


cluster_schema = {
    "controlplane": {
        "cpu_cores": Or(2, 4, 6, 8,
                        error="The number of CPU cores for the ControlPlane must be one of the following: 2, 4, 6, or 8."),
        "memory": Or(4096, 6144, 8192,
                     error="The RAM memory size for the ControlPlane must be one of the following: 4096, 6144, or 8192."),
        "disk_size": And(Use(int), lambda n: 10 <= n <= 60,
                         error="The DiskSize for the ControlPlane must be within the range of 10 to 60.")
    },
    "worker_nodes": {
        "count": And(Use(int), lambda n: 1 <= n <= 5,
                     error="The Count for the WorkerNodes must be within the range of 1 to 5."),
        "cpu_cores": Or(2, 4, 6, 8,
                        error="The number of CPU cores for the WorkerNodes must be one of the following: 2, 4, 6, or 8."),
        "memory": Or(2048, 4096, 6144,
                     error="The RAM memory size for the WorkerNodes must be one of the following: 2048, 4096 or 6144."),
        "disk_size": And(Use(int), lambda n: 10 <= n <= 60,
                         error="The DiskSize for the WorkerNodes must be within the range of 10 to 60.")
    }
}


def main():
    # Collect values from out of the file
    parser = argparse.ArgumentParser()
    parser.add_argument("--yaml-path", type=pathlib.Path, help="YAML configuration file path.", required=True)
    parser.add_argument("--cluster-name", type=str, help="A cluster name for checking the validity.", default=None)
    args = parser.parse_args()

    if not os.path.isfile(args.yaml_path):
        raise FileNotFoundError(f"File {args.yaml_path} does not exist.")

    with open(args.yaml_path, 'r') as file:
        yaml_content = file.read()

    try:
        # Check if file is not empty
        if len(yaml_content.strip()):
            loaded_yaml_content = yaml.safe_load(yaml_content)
            check_empty_lines(yaml_content=yaml_content)
            # Wrap the cluster schema with the cluster names validator
            schema = Schema(And(lambda cluster_schema: validate_cluster_names(cluster_schema, args.cluster_name), {str: cluster_schema}))
            schema.validate(loaded_yaml_content)
        print("YAML configuration file is valid.")
    except yaml.YAMLError as e:
        print(f"Error parsing YAML configuration file: {e}")
        sys.exit(1)
    except SchemaError as e:
        print(f"Invalid YAML configuration: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
