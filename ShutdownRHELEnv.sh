#!/usr/bin/env bash
export PRGNAME=$(basename "$0" .sh)

export FUSION=$(mdfind "VMware Fusion.app" 2>/dev/null | grep '\.app$' | tail -n1)
export VMRUN=$(find "$FUSION" -type f -name "vmrun")
export VDISK=$(find "$FUSION" -type f -name "vmware-vdiskmanager")
export VMTMPL=${VMTMPL:="/Users/Shared/VM/RHEL9.6 template.vmwarevm/RHEL9.6 template.vmx"}
export VMDEST=${VMDEST:="/Users/Shared/VM"}

if [ -n "$FUSION" ] && [ -f "$VMRUN" ] ; then
    for i in 5 4 3 2 -control ; do
        if [ -f "$VMDEST/ansible${i}.vmwarevm/ansible${i}.vmx" ] ; then
            printf "$PRGNAME: stopping ansible${i}.vmwarevm ..." >&2
            "$VMRUN" stop "$VMDEST/ansible${i}.vmwarevm/ansible${i}.vmx" nogui
            printf " done.\n" >&2
        fi
    done
else
    printf "$PRGNAME: could not find Fusion or 'vmrun', exiting...\n" >&2
    exit 1
fi
