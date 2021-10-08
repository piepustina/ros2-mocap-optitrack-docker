# syntax=docker/dockerfile:1
FROM ubuntu:20.04
# Use the bash shell
SHELL ["/bin/bash", "-c"]
#
# Get the updates
RUN apt-get update -y
#
# Install Eigen library
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y apt-utils libeigen3-dev
#
# Install ROS2
RUN apt-get install -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt-get update && apt-get install curl gnupg2 lsb-release -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt-get update && DEBIAN_FRONTEND=noninteractive  apt-get install ros-foxy-desktop -y
#
# Install colcon
RUN curl -s https://packagecloud.io/install/repositories/dirk-thomas/colcon/script.deb.sh | bash
RUN apt-get install python3-colcon-common-extensions -y
#
# Set all the envinorment variables
ENV ROS_DOMAIN_ID=1
ENV _colcon_cd_root=~/ros2_install
# Install git
RUN apt-get install -y git
# Create the working directories
RUN mkdir /home/mocap /home/mocap/src 
WORKDIR "/home/mocap"
# Clone the repository for the motion capture system
#RUN git clone https://github.com/tud-cor-sr/ros2-mocap_optitrack.git ./src

# Build the packages
#RUN source /opt/ros/foxy/setup.bash;\
#    source /usr/share/colcon_cd/function/colcon_cd.sh;\
#    colcon build
#    . install/setup.bash


CMD source /opt/ros/foxy/setup.bash;\
    source /usr/share/colcon_cd/function/colcon_cd.sh;\
    git clone https://github.com/tud-cor-sr/ros2-mocap_optitrack.git ./src;\
    colcon build;\
    . install/setup.bash;\
    ros2 launch ./src/launch/launch_y_up.py

#RUN apt-get install -y iputils-ping
#CMD ping 10.125.37.1;