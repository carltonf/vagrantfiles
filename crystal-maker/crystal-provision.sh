#!/bin/bash
# NOTE by default there is no need for sudo, as vagrant runs script with sudo.

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed --assume-installed=xclip \
     git mosh neovim fish p7zip pass rsync sdcv the_silver_searcher tmux wget stow sshpass sshfs
sudo ln -sv /usr/bin/nvim /usr/local/bin/vi

# Set root password to 'vagrant' for convenience.
echo 'root:vagrant' | sudo chpasswd
# Enable passwd login for root
sudo sed -i -e 's/^#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo chsh -s /usr/bin/fish vagrant

# Default Arch keymap is not set, but the base box we use have it set to `es`
sudo localectl set-keymap --no-convert us

# Clean up
sudo pacman -Scc --noconfirm
cat /dev/null > ~/.bash_history && history -c && exit
