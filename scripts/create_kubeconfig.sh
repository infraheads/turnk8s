#!/usr/bin/env bash

cat <<EOF > "/tmp/kube-config"
$(echo "$1" | tail -n +2 | head -n -1)
EOF