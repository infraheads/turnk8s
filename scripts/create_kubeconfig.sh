#!/usr/bin/env bash

cat <<EOF > "/opt/kubeconfig/$2"
$(echo "$1" | tail -n +2 | head -n -1)
EOF
