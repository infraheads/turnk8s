turnk8s
=================

## Introduction

**turnk8s** is run Kubernetes service based on `yaml` configuration file. Clusters are run in [Talos Linux](https://www.talos.dev) on [Proxmox](https://www.proxmox.com) server. 
For each cluster is created GitHub repository which contains Kubernetes manifests are managed by ArgoCD.  


## GitHub

It is possible to manage cluster(s) via the `inputs.yaml` configuration file. You can create or destroy cluster(s) 
by changing the configuration file.
<details>
  <summary>Click here to see the structure of configuration file:</summary>

```yaml
- cluster_name: turnk8s-cluster
  versions:
    talos: v1.7.1
    k8s: v1.30.0
  controlplane:
    cpu_cores: 2
    memory: 4096
    disk_size: 20
  worker_node:
    count: 2
    cpu_cores: 2
    memory: 4096
    disc_size: 20
```
</details>


### Creating a Cluster
For creating a cluster you need to configure `inputs.yaml` configuration file by adding the above structure into inputs.yaml file.  

Here is the descriptions of the configuration values:
* **cluster_name:(Required)** - The cluster name which must be unique
* **versions.talos:(Required)** - Talos Linux version: the possible versions are v1.7.1, v1.7.1, v1.6.7
* **versions.k8s:(Required)** - Kubernetes version: the possible versions are v1.30.0, v1.29.3, v1.6.7
* **controlplane.cpu_cores:(Required)** - CPU cores count of the ControlPlane:(minimum requirement count is 2)
* **controlplane.memory:(Required)** - RAM memory of the ControlPlane:(minimum requirement size is 2048)
* **controlplane.disk_size:(Required)** - Disk size of the ControlPlane:(minimum requirement size is 10)
* **worker_node.count:(Required)** - Count of the Worker Nodes
* **worker_node.cpu_cores:(Required)** - CPU cores count of the Worker Node:(minimum requirement count is 1)
* **worker_node.memory:(Required)** - RAM memory of the Worker Node:(minimum requirement size is 2048)
* **worker_node.disc_size:(Required)** - Disk size of the Worker Node:(minimum requirement size is 10)

Now all you need to do is pushing the changes into GitHub. Then it automatically implements changes appropriate to the configuration file.
It is completed within 5 minutes.

After workflow is completed, click on the `artifact` to download `kubeconfig` configuration file. You can go to a given GitHub url, add your Kubernetes manifests and enjoy the result.


### Destroying a Cluster
For destroying a cluster you need to remove the cluster configuration from `input.yaml` file and push it into GitHub.
Then it will be eliminated during 1-2 minutes.


## Kubectl

Now `unzip` the downloaded kubeconfig and export it as a `KUBECONFIG` variable.
<br>
Try `kubectl get node` to check Kubernetes is running.

#### Congratulations!!! Kubernetes cluster ready to deploy and manage your containerized applications.