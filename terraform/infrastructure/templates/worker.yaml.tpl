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
    network:
        hostname: ${node-name}