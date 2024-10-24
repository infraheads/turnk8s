# This script based on config.yaml file and existing terraform workspaces, decided which clusters must be deleted and/or updated
import os
import re
import yaml
import pathlib
import argparse
from collections import Counter


def main():
    # Collect values from out of the file
    parser = argparse.ArgumentParser()
    parser.add_argument("--yaml-path", type=pathlib.Path, help="YAML configuration file path.", required=True)
    parser.add_argument("--existing-clusters", type=str, help="Existing clusters name.", required=True)
    args = parser.parse_args()

    if not os.path.isfile(args.yaml_path):
        raise FileNotFoundError(f"File {args.yaml_path} does not exist.")

    with open(args.yaml_path, 'r') as file:
        yaml_content = file.read()

    loaded_yaml_content = yaml.safe_load(yaml_content) or dict()

    # Desired clusters must be applied
    desired_clusters = Counter([str(cluster) for cluster in loaded_yaml_content.keys()])
    # Existing clusters filtered from "terraform workspace list" and remove prefixes
    existing_clusters = Counter([re.sub(r'(-infrastructure|-cluster)$', '', cluster) for cluster in args.existing_clusters.split() if re.compile(r'^(?!\d).*(-infrastructure|-cluster)$').match(cluster)])
    # Removed unique name
    existing_clusters = Counter([cluster for cluster, count in existing_clusters.items() if count == 2])
    # The clusters must be destroyed
    removable_clusters = existing_clusters - desired_clusters

    # print the output as comma separated
    print(" ".join(desired_clusters), " ".join(removable_clusters), sep=",")

if __name__ == '__main__':
    main()
