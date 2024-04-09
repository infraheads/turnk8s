Kubernetes in Talos Linux on Proxmox Server
=================

## Introduction

The purpose of this task is run Kubernetes service in Talos Linux on Proxmox server.


## Overview

The task is divided into following stages:

* Set the desirable values into `workflow_dispatch` of Github and run workflow to create a Cluster (this step is not automated).
* Setting up Proxmox VMs installed Talos Linux.
    * created VMs depends on previous step
    * one for control plane and the rest for worker nodes
    * generated Talos configuration for each VM and applied them to config VMs as control plane and worker node(s).
* After creating the Cluster, when Kubernetes is installed, download the `kubeconfig artifact` for connecting to the Kubernetes server.


## GitHub

It is possible to manage cluster(s) from GitHub UI. You can create or destroy cluster(s) by one click.

### Creating a Cluster
For creating a cluster you need to configure some variables in workflow. To run the workflow 
go to **Actions>Create a Cluster>Run workflow** 

There are some necessary variables shown in bellow:
* **ClusterName:(Required)** - the cluster name which must be unique
* **ControlPlaneCPU:(Optional)** - CPU cores count of the ControlPlane
* **ControlPlaneMemory:(Optional)** - RAM memory of the ControlPlane
* **ControlPlaneDiskSize:(Optional)** - Disk size of the ControlPlane
* **WorkerNodesCount:(Optional)** - Count of the Worker Nodes
* **WorkerNodeCPU:(Optional)** - CPU cores count of the Worker Node
* **WorkerNodeMemory:(Optional)** - RAM memory of the Worker Node
* **WorkerNodeDiskSize:(Optional)** - Disk size of the Worker Node

Click on the `Run workflow` button to create the cluster. It is completed within 10 minutes 
and another 10 minutes for configuring VMs.

After workflow is completed, click on the `artifact` to download `kubeconfig` configuration file.


### Destroying a Cluster
For destroying a cluster you need to run the following workflow: **Actions>Destroy Kubernetes Cluster>Run workflow.** 
You need to set the cluster name you want to delete.

* **ClusterName:(Required)** - the cluster name which must be deleted

Click on the `Run workflow` button to destroy the cluster. It is completed within 10 minutes.

It is possible to create a cluster with the same name, after workflow is completed. 

## Kubectl

Now insert the output value of `exporting_kubeconfig`. Run `terraform output exporting_kubeconfig` command to view again the output.
<br>
Try `kubectl get node` to check Kubernetes is running or not.

#### Congratulations!!! Kubernetes cluster ready to deploy and manage your containerized applications.