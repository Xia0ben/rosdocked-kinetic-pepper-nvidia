#!/usr/bin/env bash

# Check args
if [ "$#" -ne 2 ]; then
  echo "usage: ./run.sh IMAGE_NAME CONTAINER_NAME"
  return 1
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e


XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# Run the container with shared X11
sudo docker run\
  --privileged\
  --net=host\
  -e SHELL\
  --env="DISPLAY=$DISPLAY"\
  --env="QT_X11_NO_MITSHM=1"\
  -env="XAUTHORITY=$XAUTH"\
  --volume="$XAUTH:$XAUTH"\
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --runtime=nvidia\
  -e DOCKER=1\
  -v "$HOME:$HOME:rw"\
  --name $2\
  -it $1 $SHELL
