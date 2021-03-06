# -*- mode: shell-script -*- 

# Enhanced vagrant functions: to be sourced from ~/.bashrc

## For Vagrant, notably some Windows programs still expect to see Windows path style
if [ "$(hostname)" = "cx5510" ]; then
    export VAGRANT_HOME='D:/Home/.vagrant.d'
fi
function vagrantq {
    local vagrant_vm_name="$1"
    if [ x = x"$vagrant_vm_name" ]; then
        echo "Info: Vagrant VM name not given. Show global status and switching to vagrantfiles."
        vagrant global-status
    fi
    # NOTE the rest args will be assumed as args passed to vagrant command
    shift

    local vagrant_runtime_base=${HOME}/Vagrant/vagrantfiles/
    local vagrant_vm="${vagrant_runtime_base}/${vagrant_vm_name}"
    if [ -d "$vagrant_vm" ]; then
        if [ "$#" -gt 0 ]; then
            pushd "$vagrant_vm" > /dev/null
            vagrant "$*"
            popd > /dev/null
        else
            # NOTE default action is only to cd
            cd "$vagrant_vm"
            echo "INFO: switching to Vagrant VM working directory."
        fi
    else
        echo "Error: Not valid Vagrant VM name. Abort."
        return -2;
    fi
}

# NOTE workaround for vagrant 1.9.5 as 'vagrant ssh' doesn't work well under
# MobaXterm due to the pecularity of MobaXterm's tty
function vagrant-ssh {
    # NOTE: check port to speed things up
    if [ "$PREV_VAGRANT_SSH_VM_ROOT" != "$(pwd)" ]; then
        # NOTE: `vagrant port` output has weird control characters, looks like
        # `$'\E[0m2200\E[0m\r'`
        export SSH_FORWARDED_PORT=$(vagrant port --guest 22 | grep -o -E '[0-9]{2,}')
        export PREV_VAGRANT_SSH_VM_ROOT="$(pwd)"
    fi
    local ssh_port="$SSH_FORWARDED_PORT"

    # TODO: To use the key file. `vagrant ssh-config` would also list the keyfile
    sshpass -p vagrant ssh -p "${ssh_port}" vagrant@localhost "$*"
}
