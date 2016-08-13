#!/bin/bash
# NOTE by default there is no need for sudo, as vagrant runs script with sudo.

pacman -Syu --noconfirm
pacman -S --noconfirm --needed --assume-installed=xclip               \
       git mosh neovim fish pass the_silver_searcher tmux stow sshfs  \
       p7zip rsync sdcv wget sshpass                                  \
       samba docker docker-compose                                    \
       nodejs npm
ln -sv /usr/bin/nvim /usr/local/bin/vi

# Set root password to 'vagrant' for convenience.
echo 'root:vagrant' | chpasswd
# Enable passwd login for root
sed -i -e 's/^#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd

chsh -s /usr/bin/fish vagrant

# Default Arch keymap is not set, but the base box we use have it set to `es`
localectl set-keymap --no-convert us

# the base box we used by default doesn't enable vbox service
systemctl enable vboxservice
# Manage Samba
# Install the preconfigured, passwordless vagrant samba share
install -m 0644 /vagrant/smb.conf /etc/samba/smb.conf
systemctl enable smbd
# manage Docker
usermod -aG docker vagrant
systemctl enable docker
# FUSE settings: s.t. sshfs mounted directory may be seen in windows
sed -i -re 's/#(user_allow_other)/\1/' /etc/fuse.conf

# for convenience
timedatectl set-timezone Asia/Shanghai

# LAST STEP: Clean up
sudo pacman -Scc --noconfirm
cat /dev/null > ~/.bash_history && history -c && exit

# -*- buffer-file-coding-system: utf-8-unix -*-
