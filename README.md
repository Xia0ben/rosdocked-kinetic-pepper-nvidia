## rosdocked

Run ROS Kinetic / Ubuntu Xenial within Docker on any linux platform with a shared username, home directory, and X11.

This enables you to build and run a persistent ROS Kinetic workspace as long as you can run Docker images.

Note that any changes made outside of your home directory from within the Docker environment will not persist. If you want to add additional binary packages without having to reinstall them each time, add them to the Dockerfile and rebuild.

For more info on Docker see here: https://docs.docker.com/engine/installation/linux/ubuntulinux/

### Build

To build the image yourself, simply follow the next instructions.

This will create the image with your user/group ID and home directory.

First, you need to install the nvidia-specific packages :

```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install nvidia-docker
```

Finally, build the image :

```
./build.sh <IMAGE_NAME>
```

### Run

You must first download the NaoQi SDK on Softbank Robotics Website (create an account and download the "pynaoqi-python-2.7-naoqi-x.x-linux32.tar.gz" file on the [Aldebaran Website](https://community.aldebaran.com/en/resources/software) with a version adequate to the Naoqi version your Pepper has installed on itself). The archive must be extracted into a "~/catkin_ws/src/naoqi_sdk" folder and the resulting subfolder must be renamed into "pynaoqi".

Then you can run the docker image.

```
./run.sh <IMAGE_NAME> <CONTAINER_NAME>
```

### Getting started with Pepper

The following instructions are inspired by the [official getting started tutorial](http://wiki.ros.org/pepper/Tutorials).

To make things easier, we suggest adding two aliases to your .bashrc, so that you don't spend hours typing the same lines over and over again. The first alias sources different files so that ros commands autocompletion works properly. The second one calls upon the first and sets two environment variables that allow the ROS-to-Pepper bridge to work properly. Every time you do a "catkin build" or "catkin_make" to build your ros packages, do a "pepper_init" right after to be sure that you've sourced the newly built files properly.

```
# On the host bash session
echo 'alias ros_init="source /opt/ros/kinetic/setup.bash && source /usr/share/gazebo/setup.sh && source ~/catkin_ws/devel/setup.bash"' >> ~/.bashrc
echo 'alias pepper_init="ros_init && export AL_DIR=$HOME/catkin_ws/src/pepper/naoqi_sdk && export PYTHONPATH=$PYTHONPATH:$AL_DIR/pynaoqi"' >> ~/.bashrc
```

To get started with Pepper, once you are on the same network as Pepper and know its IP address (quickly press the power button on its chest for it to spell it and ping this address), the container is launched and you are sshed in it start a roscore :

```
# Inside the container bash session
roscore
pepper_init
```

Open another terminal and log into the docker container :

```
# On the host bash session
sudo docker exec -it <CONTAINER_NAME> bash
# Inside the container bash session
pepper_init
```

Then, to start making your roscore communicate with Pepper, do :

```
# Inside the container bash session
roslaunch pepper_bringup pepper_full.launch nao_ip:=<YOUR_PEPPER_IP> roscore_ip:=localhost network_interface:=<YOUR_NETWORK_INTERFACE>
```

Open yet another terminal, log into the docker container and launch rviz to see the state of Pepper in real time :

```
# Inside the container bash session
rviz rviz -d $HOME/catkin_ws/src/pepper/naoqi_driver/share/pepper.rviz
```

You'll probably need, for the laser sensors, sonars, point cloud and camera feed to display properly, to change the default  topics that are being listened by rviz to another (simply click on it in the left column and a menu proposing only the likely appropriate topics will appear).
