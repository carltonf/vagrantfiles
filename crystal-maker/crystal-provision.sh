#!/bin/bash
# NOTE by default there is no need for sudo, as vagrant runs script with sudo.

pacman -Syu --noconfirm
pacman -S --noconfirm --needed --assume-installed=xclip               \
       git mosh neovim fish pass the_silver_searcher tmux stow sshfs  \
       p7zip rsync sdcv wget sshpass dnsutils gdb pkgfile             \
       samba docker docker-compose dnsmasq
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
install -m 0600 /vagrant/etc-docker-daemon.json /etc/docker/daemon.json
# FUSE settings: s.t. sshfs mounted directory may be seen in windows
sed -i -re 's/#(user_allow_other)/\1/' /etc/fuse.conf

# for convenience
timedatectl set-timezone Asia/Shanghai

# Network naming: use the enp0sX (specific to Terrywang)
rm -vf /etc/udev/rules.d/66-persistent-net.rules
netctl disable eth0
rm -vf /etc/netctl/eth0
cp -v /etc/netctl/{examples/ethernet-dhcp,enp0s3}
sed -i 's/eth0/enp0s3/g' /etc/netctl/enp0s3
netctl enable enp0s3

# reverse some terrywang configurations
rm -vf /home/vagrant/.tmux.conf
# LANG is set to en_AU.utf-8, non-crucial changes, I'll omit here

# LAST STEP: Clean up and freeze the time
sudo pacman -Scc --noconfirm
cat /dev/null > ~/.bash_history && history -c && exit
## NOTE really useful as we can avoid new package installation requiring system upgrade.
# Ref: https://wiki.archlinux.org/index.php/Arch_Linux_Archive
echo "Server=https://archive.archlinux.org/repos/$(date +%Y/%m/%d)/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

# -*- buffer-file-coding-system: utf-8-unix -*-
