Kubernetes in Talos Linux on Proxmox Server
=================

## Introduction

The purpose of this task is run Kubernetes service in Talos Linux on Proxmox server.


## Overview

The task is divided into following stages:

* Set the desirable values into `terraform.tfvars` and running terraform (this step is not automated).
* Setting up Proxmox VMs installed Talos Linux.
    * created 2 VMs
    * one for control plane and another one for worker node
    * generated Talos configuration for each VM and applied them to config VMs as control plane and worker node.
* After creating Terraform resources, when Kubernetes is installed, run the `terraform output exporting_kubeconfig` command to view the steps for connecting to the Kubernetes server


## Terraform

Configure variables in [terraform.tfvars](terraform/terraform.tfvars) 

There are some required variables must be entered:
* ssh_key_path - the ssh key path to connect to the Proxmox server
* proxmox_ip - the Proxmox server ip address for connecting to the Proxmox API
* proxmox_token_id - the API token created for a user
* proxmox_token_secret - the uuid is only available when the token was initially created

Run `terraform apply` after setting up variables. It is completed within 10 minutes.

<details>
  <summary>Terraform Output:</summary>

```bash
# output truncated
talos_machine_secrets.talos_secrets: Creating...
random_integer.wn_vm_id: Creating...
random_integer.cp_vm_id: Creating...
random_integer.wn_vm_id: Creation complete after 0s [id=612455947]
random_integer.cp_vm_id: Creation complete after 0s [id=651857194]
talos_machine_secrets.talos_secrets: Creation complete after 0s [id=machine_secrets]
proxmox_vm_qemu.worker: Creating...
proxmox_vm_qemu.controlplane: Creating...
.................
.................
.................
talos_machine_bootstrap.cp_mb: Still creating... [7m50s elapsed]
talos_machine_bootstrap.cp_mb: Creation complete after 7m58s [id=machine_bootstrap]
data.talos_cluster_kubeconfig.cp_ck: Reading...
data.talos_cluster_kubeconfig.cp_ck: Read complete after 0s [id=cp-651857194]
null_resource.kubeconfig: Creating...
null_resource.kubeconfig: Provisioning with 'local-exec'...
null_resource.kubeconfig (local-exec): (output suppressed due to sensitive value in config)
null_resource.kubeconfig: Creation complete after 0s [id=501172468417831007]

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

cp_ip = "192.168.1.162"
wn_ip = "192.168.1.161"
exporting_kubeconfig = <<EOT
export KUBECONFIG="/tmp/651857194"
EOT
```
</details>

After `terraform apply` is completed, starting configuration VMs, which takes about 8-10 minutes.


## Kubectl

Now insert the output value of `exporting_kubeconfig`. Run `terraform output exporting_kubeconfig` command to view again the output.
<br>
Try `kubectl get node` to check Kubernetes is running or not.

#### Congratulations!!! Kubernetes cluster ready to deploy and manage your containerized applications.