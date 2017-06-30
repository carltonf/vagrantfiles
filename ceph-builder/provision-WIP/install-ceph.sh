#!/bin/sh
# Install docker from upstream for Ubuntu Xenial 16.04 (LTS)

# Ref: http://docs.master.dockerproject.org/engine/installation/linux/ubuntulinux/

sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update

# NOTE: not really necessary
sudo apt-get purge lxc-docker
apt-cache policy docker-engine

# For aufs
sudo apt-get install linux-image-extra-$(uname -r)

sudo apt-get install docker-engine

# Should be enabled by default
sudo systemctl enable docker

# Public registry test
sudo service docker start
sudo service docker status
sudo docker run --rm hello-world

# Private registry test
if [ -e /vagrant/daemon.json ]; then
  sudo install -m0600 /vagrant/daemon.json /etc/docker/daemon.json
fi
sudo service docker restart
sudo service docker status
sudo docker run --rm crystal.cw:5000/hello-world
sudo docker images

# add vagrant to the group
sudo groupadd docker
sudo usermod -aG docker vagrant
su - vagrant
docker images
