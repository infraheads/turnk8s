#!/bin/bash

talosctl gen config talos-proxmrox https://$CONTROLPLANE_IP:6443 -o _out --force
talosctl apply-config -n $CONTROLPLANE_IP --insecure -f _out/controlplane.yaml
talosctl apply-config -n $WORKER_NODE_IP --insecure -f _out/worker.yaml

# Run after booting vm
talosctl bootstrap -e $CONTROLPLANE_IP -n $CONTROLPLANE_IP --talosconfig _out/talosconfig
talosctl kubeconfig -e $CONTROLPLANE_IP -n $CONTROLPLANE_IP --talosconfig _out/talosconfig