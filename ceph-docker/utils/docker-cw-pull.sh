#!/bin/sh

# TODO test /etc/docker/daemon.json

# Ease the image pulling from local registry
# Needed because the default registry can not be changed.
# Ref: https://github.com/moby/moby/issues/33069

REG_SERVER=crystal.cw:5000

# NOTE the name as in the docker hub
orig_img_name="$*"
local_img_name=$REG_SERVER/$orig_img_name

docker pull $local_img_name || exit 1
docker tag $local_img_name $orig_img_name
docker rmi $local_img_name

echo "* DONE!"
