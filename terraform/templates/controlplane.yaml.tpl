machine:
    kubelet:
        image: ghcr.io/siderolabs/kubelet:${kubernetes-version}
    install:
        image: ghcr.io/siderolabs/installer-qemu:${talos-version}
    registries:
        mirrors:
            '*':
                endpoints:
                    - http://${registry}
cluster:
    apiServer:
        image: registry.k8s.io/kube-apiserver:${kubernetes-version}
    controllerManager:
        image: registry.k8s.io/kube-controller-manager:${kubernetes-version}
    proxy:
        image: registry.k8s.io/kube-proxy:${kubernetes-version}
    scheduler:
        image: registry.k8s.io/kube-scheduler:${kubernetes-version}