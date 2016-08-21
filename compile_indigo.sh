sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update
sudo apt-get -y install git
# http://wiki.ros.org/indigo/Installation/Source
sudo apt-get install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
sudo rosdep init
rosdep update

mkdir ~/ros_workspace
cd ~/ros_workspace
rosinstall_generator desktop --rosdistro indigo --deps --wet-only --tar > indigo-desktop-wet.rosinstall
wstool init -j8 src indigo-desktop-wet.rosinstall

# If wstool init fails or is interrupted, you can resume the download by running:
# wstool update -j 4 -t src
# Resolving Dependencies
sudo rosdep install --from-paths src --ignore-src --rosdistro indigo -y

# for some reason class_loader requires libpocofoundationd, which is the debug version 
sudo apt-get install libpocofoundation9*

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Debug
source ~/ros_workspace/install_isolated/setup.bash
