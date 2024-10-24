#!/bin/bash

export KUBECONFIG=$(find /opt/kubeconfig -type f | tr '\n' ':')
mkdir ~/.kube
kubectl config view --flatten > ~/.kube/config