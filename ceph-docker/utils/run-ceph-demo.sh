#!/bin/bash

# TODO set up a better controlled the docker internal network
host_ip=$( host ceph-docker.cv | grep -o '[0-9.]*$' )

mkdir -pv $HOME/demo/etc

container_name="demo_daemon"

function run_demo_daemon {
    docker run -d --net=host                    \
           --name $container_name               \
           -v $HOME/demo/etc:/etc/ceph          \
           -e MON_IP=$host_ip                   \
           -e CEPH_PUBLIC_NETWORK=$host_ip/24   \
           ceph/demo
}

function run_demo_shell {
    docker exec -it $container_name /bin/bash
}

# Main

subcmd=$1
case "$subcmd" in
    daemon)
        run_demo_daemon
        ;;
    shell)
        run_demo_shell
        ;;
    *)
        echo "WARNING: unrecognized subcommand: $subcmd. Default to 'shell'."
        run_demo_shell
        ;;
esac

