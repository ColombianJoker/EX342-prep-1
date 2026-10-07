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

    for i in -control 2 3 4 5 ; do
        case "$i" in
            (-control) NAM=control ;;
            (*) NAM=$i
        esac
        printf "$PRGNAME: Cloning ${NAM} node..."
        if [ ! -d "$VMDEST/ansible${i}.vmwarevm" ] ; then
            "$VMRUN" clone "$VMTMPL" "$VMDEST/ansible${i}.vmwarevm/ansible${i}.vmx" full -cloneName="ansible${i}"
        else
            printf "$PRGNAME: $VMDEST/ansible${i}.vmwarevm exists, skipping creation...\n" >&2
        fi

        # 2. Create the secondary 1GB disk for ansible5
        if [ "$i" = "5" ] ; then
            if [ ! -f "$VMDEST/ansible${i}.vmwarevm/disk2.vmdk" ] ; then
                printf "$PRGNAME: Creating 1GB disk for node ${i}..."
                "$VDISK" -c -s 1GB -a lsilogic -t 0 "$VMDEST/ansible${i}.vmwarevm/disk2.vmdk"
            else
                printf "$PRGNAME: ansible${i}.vmwarevm/disk2.vmdk exists, skipping creation\n" >&2
            fi
        fi

    done
    # 3. Boot up the cluster! (Using nogui so they run headlessly in the background)
    echo "$PRGNAME: Starting cluster..."
    for i in -control 2 3 4 5 ; do
        printf "$PRGNAME: starting ansible${i}.vmwarevm ...\n" >&2
        "$VMRUN" start "$VMDEST/ansible${i}.vmwarevm/ansible${i}.vmx" nogui
    done
    echo "$PRGNAME: Cluster deployment complete!" >&2
else
    printf "$PRGNAME: Could not find VMware Fusion, exiting!\n" >&2
    exit 1
fi
