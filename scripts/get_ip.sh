#!/bin/bash

ssh_key_path=$1
proxmox_ip=$2
vm_ids=$3
output_file=$4

ssh -i $ssh_key_path root@$proxmox_ip  """
  for vm_id in ${vm_ids[@]}
  do
    export mac=\$(qm config \$vm_id --current | grep '^net0'| awk -F ',' '{print \$1}'| awk -F '=' '{print tolower(\$2)}');
    for i in {0..20}
    do
      export vm_ip=\$(arp-scan --interface=vmbr0 $proxmox_ip/24 | grep \$mac | awk '{printf \"%s \", \$1}');
      if [[ -n \$vm_ip ]]
      then
        echo \$vm_id \$vm_ip
        break;
      fi
      sleep 3;
    done
  done
""" > $output_file