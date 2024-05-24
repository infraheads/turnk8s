turnk8s
=================

## Introduction

**turnk8s** is a toolset for On-Prem, turnkey Kubernetes deployments based on  [Talos Linux](https://www.talos.dev) and [Proxmox](https://www.proxmox.com). 


## GitHub

Adhering to GitOps, you can manage all the clusters with the `config.yaml` configuration file. turnk8s ensures that the `config.yaml` represents the state of your running clusters.
<details>
  <summary>Click here to see the structure of config.yaml file:</summary>

```yaml
turnk8s-cluster:
  versions:
    talos: v1.7.1
    k8s: v1.30.0
  controlplane:
    cpu_cores: 2
    memory: 4096
    disk_size: 20
  worker_node:
    cpu_cores: 2
    memory: 4096
    disc_size: 20
```
</details>


### Creating a Cluster
You can create one or many clusters at once. All you need to do is add the turnk8s cluster configurations to the config.yaml file.

Configuration parameters:
* **the main key is the cluster name:(Required)** - A unique cluster name
* **versions.talos:(Required)** - Talos Linux version: Supported versions are v1.7.1, v1.7.1, v1.6.7
* **versions.k8s:(Required)** - Kubernetes version: Supported versions are v1.30.0, v1.29.3
* **controlplane.cpu_cores:(Required)** - controlplane node cores :(min 2)
* **controlplane.memory:(Required)** - controlpalne node RAM (min 2048)
* **controlplane.disk_size:(Required)** - controlplane node disk size:(min 10)
* **worker_node.cpu_cores:(Required)** - worker node cores:(min 1)
* **worker_node.memory:(Required)** - worker node RAM:(min 2048)
* **worker_node.disc_size:(Required)** - worker node disk size:(min 10)

Pushing config.yaml triggers a GitHub actions workflow. When the workflow is complete, the Kubernetes configuration files and the Kubernetes services repo URL are shown on the summary page.
Push manifests to the Kubernetes services repo to get them deployed on the Kubernetes cluster.


### Destroying a Cluster
For destroying a cluster, you need to remove the cluster configuration from the `config.yaml` file and push it to your turnk8s repository.

## Kubectl

Now `unzip` the downloaded kubeconfig and export it as a `KUBECONFIG` variable.
<br>
Try `kubectl get node` to check Kubernetes is running.

#### Congratulations!!! Kubernetes cluster is ready to deploy and manage your containerized applications.
