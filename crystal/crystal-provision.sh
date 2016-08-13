#!/bin/sh

cd $HOME

# `--recursive` to make sure that all submodules are initialized as well.
git clone --recursive /Dropbox/icrepos-bare/dotfiles.git
cd dotfiles
/bin/bash ./Init.sh

cd $HOME
tar xvf /Dropbox/icrepos-bare/manual.nongit/dot.gnupg.tar
echo '** INFO: pseduoSensitive requires manual management'
# Enable daocloud docker accelarator
sudo install -m 0644 -D -t /etc/systemd/system/docker.service.d/ \
     /Dropbox/icrepos-bare/manual.nongit/docker/daocloud.conf

# ssh configs
cd $HOME
install -vm 0700 -d .ssh
install -vm 0700 -d .ssh/controlmasters
# sensitive ssh keys: encrypted though
CW_SSH_KEYS_DIR=/Dropbox/icrepos-bare/manual.nongit/ssh/.ssh
install -vm 0600 ${CW_SSH_KEYS_DIR}/id_rsa-crystal-w .ssh/
install -vm 0600 ${CW_SSH_KEYS_DIR}/id_rsa-crystal-w.pub .ssh/

# Enable user systemd service
#
# NO need to enable them here, as this settings can be managed in `dotfiles`.
# However a daemon-reload is needed to info systemd this fact and start them
# manually s.t. they are available immediately after provisioning.
#
# Make sure `--user` toggle is on
sysctrluser='systemctl --user'
$sysctrluser daemon-reload
$sysctrluser start tmux.service
$sysctrluser start gpg-agent.service
$sysctrluser start ssh-agent.service

# IMPORTANT: Enable lingering: necessary for session-persistent tmux and agents.
#
# see https://lists.freedesktop.org/archives/systemd-devel/2016-May/036583.html
# and man page on logind.conf and loginctl
sudo loginctl enable-linger

# About data:
# Backup important data with Dropbox, host directories and git repo.

