# -*- mode: shell-script -*- 

# Enhanced vagrant functions: to be sourced from ~/.bashrc

## For Vagrant, notably some Windows programs still expect to see Windows path style
if [ "$(hostname)" = "cx5510" ]; then
    export VAGRANT_HOME="D:/Carl Xiong/.vagrant.d"
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

# NOTE work around for vagrant 1.9.5 as 'vagrant ssh' doesn't work any more.
# (acutally the interactive ssh doesn't work since 1.8)
function vagrant-ssh {
    # NOTE: check port to speed things up
    if [ x"$SSH_FORWARDED_PORT" = x ]; then
        # NOTE: vagrant port has weird control characters, looks like `$'\E[0m2200\E[0m\r'`
        export SSH_FORWARDED_PORT=$(vagrant port --guest 22 | grep -o -E '[0-9]{2,}')
    else
	      echo "WARNING: Reuse old PORT $SSH_FORWARDED_PORT. If wrong, run 'unset SSH_FORWARDED_PORT'."
    fi
    local ssh_port="$SSH_FORWARDED_PORT"

    sshpass -p vagrant ssh -p "${ssh_port}" vagrant@localhost "$*"
    # sshpass -p vagrant ssh -p 2200 vagrant@localhost
}
