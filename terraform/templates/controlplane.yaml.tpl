machine:
    kubelet:
        image: ghcr.io/siderolabs/kubelet:${kubernetes-version}
    install:
        image: ghcr.io/siderolabs/installer:${talos-version}
cluster:
    apiServer:
        image: registry.k8s.io/kube-apiserver:${kubernetes-version}
    controllerManager:
        image: registry.k8s.io/kube-controller-manager:${kubernetes-version}
    proxy:
        image: registry.k8s.io/kube-proxy:${kubernetes-version}
    scheduler:
        image: registry.k8s.io/kube-scheduler:${kubernetes-version}