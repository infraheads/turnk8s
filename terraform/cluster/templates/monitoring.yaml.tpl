prometheusOperator:
  image:
    registry: ${registry}
    repository: "prometheus-operator/prometheus-operator"
    tag: "v0.74.0"
  prometheusConfigReloader:
    image:
      registry: ${registry}
      repository: "prometheus-operator/prometheus-config-reloader"
      tag: "v0.74.0"
prometheus:
  service:
    type: LoadBalancer
  prometheusSpec:
    image:
      registry: ${registry}
      repository: "prometheus/prometheus"
      tag: "v2.53.0"
    volumeClaimTemplate:
      spec:
        storageClassName: ${storage-class}
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 5Gi
alertmanager:
  alertmanagerSpec:
    image:
      registry: ${registry}
      repository: "prometheus/alertmanager"
      tag: "v0.27.0"
grafana:
  service:
    type: LoadBalancer
  image:
    registry: ${registry}
    repository: "grafana/grafana"
    tag: "11.0.0"
  sidecar:
    image:
      registry: ${registry}
      repository: "kiwigrid/k8s-sidecar"
      tag: "1.26.1"
  persistence:
    enabled: true
    storageClassName: ${storage-class}
    accessModes:
      - ReadWriteOnce
    size: 3Gi
    finalizers:
      - kubernetes.io/pvc-protection
kube-state-metrics:
  image:
    registry: ${registry}
    repository: "kube-state-metrics/kube-state-metrics"
    tag: "v2.12.0"
