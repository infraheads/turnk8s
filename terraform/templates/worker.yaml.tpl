machine:
    kubelet:
        image: ghcr.io/siderolabs/kubelet:${kubernetes-version}
    install:
        image: ghcr.io/siderolabs/installer:${talos-version}
    registries:
        mirrors:
            '*':
                endpoints:
                    - ${registry}