#!/bin/bash

ssh_key_path=$1
proxmox_ip=$2
output_file=$3
vm_id=$4

ssh -i $ssh_key_path root@$proxmox_ip  """
  export mac=\$(qm config $vm_id --current | grep '^net0'| awk -F ',' '{print \$1}'| awk -F '=' '{print tolower(\$2)}');
  for i in {0..10}
  do
    export vm_ip=\$(arp-scan --interface=vmbr0 $proxmox_ip/24 | grep \$mac | awk '{printf \"%s \", \$1}');
    if [[ -n \$vm_ip ]]
    then
      echo \$vm_ip;
      break;
    fi
    sleep 3;
  done
""" | tr -d '\n' > $output_file