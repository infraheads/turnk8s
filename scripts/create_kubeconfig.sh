#!/usr/bin/env bash

cat <<EOF > "/tmp/test"
$(echo "$2" | tail -n +2 | head -n -1)
EOF