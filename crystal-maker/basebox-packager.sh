#!/bin/bash
#
# Script to create a box from 'crystal-maker' and import it into local box
# registry.
# Tested with bash bundled with 'git-for-windows'.

baseboxName='crystal-maker'

vmid=$(VBoxManage list vms | grep -o $baseboxName'[^"]*')
dateTag=$(date +%Y%m%d)         # format like 20160713
boxFileName="${baseboxName}-${dateTag}.box"

if [[ -z "$vmid" ]]; then
    echo "ERROR: Can not found '$baseboxName' VM instance."
    exit -1
fi

echo "* Packaging $baseboxName"
vagrant halt
vagrant package --base $vmid --output $boxFileName

vagrant box remove $baseboxName
vagrant box add --name $baseboxName $boxFileName

# list box to be sure
vagrant box list

### TODO
# box metadata like the version, see https://www.vagrantup.com/docs/boxes/format.html

