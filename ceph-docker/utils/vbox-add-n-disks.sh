#!/bin/sh

if [ $# -lt 2 ]; then
    echo "* ERROR: num and size args are required! Abort."
    exit 1
fi

num=$1
# in megabytes (as createvm)
size=$2

echo "* INFO: Creating $num disks of size $size MB."

VMID=$(cat .vagrant/machines/default/virtualbox/id)

i=0
while [ $i -lt $num ]; do
    disk_fn="osd$i.vdi"
    # WARNING: make sure it skips the existing ports
    port_num=$(($i + 1))
    if [ -e "$disk_fn" ]; then
        # NOTE: make sure the old disks are purged
        VBoxManage.exe closemedium disk "$disk_fn" --delete
    fi

    echo "* Created and attached HDD $disk_fn"
    VBoxManage createhd --filename "$disk_fn" --size $size
    VBoxManage.exe storageattach $VMID                        \
                   --storagectl "SATA Controller" --device 0  \
                   --port "$port_num" --type hdd --medium "$disk_fn"

    i=$(($i + 1))
done

echo "* DONE."
