#!/usr/bin/env bash

export PRGNAME=$(basename "$0" .sh)
# Find VMware Fusion
export FUSION=$(mdfind "VMware Fusion.app" 2>/dev/null | grep '\.app$' | tail -n1)
if [ -n "$FUSION" ] ; then
  # Define your exact paths and tools
  export VMRUN=$(find "$FUSION" -type f -name "vmrun")
  export VDISK=$(find "$FUSION" -type f -name "vmware-vdiskmanager")
  export VMTMPL=${VMTMPL:="/Users/Shared/VM/RHEL9.6 template.vmwarevm/RHEL9.6 template.vmx"}
  export VMDEST=${VMDEST:="/Users/Shared/VM"}

  echo "$PRGNAME: Processing..." >&2
  # 1. Create the clones (This will take a minute or two as it copies the 1.9G vmdk)
  echo "$PRGNAME: Cloning control node..."
  "$VMRUN" clone "$VMTMPL" "$VMDEST/ansible-control.vmwarevm/ansible-control.vmx" full -cloneName="ansible-control"

  echo "$PRGNAME: Cloning node 2..."
  "$VMRUN" clone "$VMTMPL" "$VMDEST/ansible2.vmwarevm/ansible2.vmx" full -cloneName="ansible2"

  echo "$PRGNAME: Cloning node 3..."
  "$VMRUN" clone "$VMTMPL" "$VMDEST/ansible3.vmwarevm/ansible3.vmx" full -cloneName="ansible3"

  echo "$PRGNAME: Cloning node 4..."
  "$VMRUN" clone "$VMTMPL" "$VMDEST/ansible4.vmwarevm/ansible4.vmx" full -cloneName="ansible4"

  echo "$PRGNAME: Cloning node 5..."
  "$VMRUN" clone "$VMTMPL" "$VMDEST/ansible5.vmwarevm/ansible5.vmx" full -cloneName="ansible5"

  # 2. Create the secondary 1GB disk for ansible5
  echo "$PRGNAME: Creating 1GB disk for node 5..."
  "$VDISK" -c -s 1GB -a lsilogic -t 0 "$VMDEST/ansible5.vmwarevm/disk2.vmdk"

  # 3. Boot up the cluster! (Using nogui so they run headlessly in the background)
  echo "$PRGNAME: Starting cluster..."
  "$VMRUN" start "$VMDEST/ansible-control.vmwarevm/ansible-control.vmx" nogui
  "$VMRUN" start "$VMDEST/ansible2.vmwarevm/ansible2.vmx" nogui
  "$VMRUN" start "$VMDEST/ansible3.vmwarevm/ansible3.vmx" nogui
  "$VMRUN" start "$VMDEST/ansible4.vmwarevm/ansible4.vmx" nogui
  "$VMRUN" start "$VMDEST/ansible5.vmwarevm/ansible5.vmx" nogui

  echo "$PRGNAME: Cluster deployment complete!" >&2
else
  printf "$PRGNAME: Could not find VMware Fusion, exiting!\n" >&2
  exit 1
fi