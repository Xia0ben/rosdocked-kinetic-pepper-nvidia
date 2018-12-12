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

# Run the container with shared X11
sudo nvidia-docker run\
  --privileged\
  --net=host\
  -e SHELL\
  --env="DISPLAY=$DISPLAY"\
  --env="QT_X11_NO_MITSHM=1" \
  -e DOCKER=1\
  -v "$HOME:$HOME:rw"\
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --name $2\
  -it $1 $SHELL
