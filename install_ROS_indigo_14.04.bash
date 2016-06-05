
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update

sudo apt-get install -y build-essential
sudo apt-get install -y git
sudo apt-get install -y gitk
sudo apt-get install -y vim
sudo apt-get install -y meld
sudo apt-get install -y terminator
sudo apt-get install -y htop
sudo apt-get install -y python-wstool


# install ros
sudo apt-get install -y ros-indigo-desktop-full
#install moveit
sudo apt-get install -y ros-indigo-moveit-full


sudo apt-get install -y cmake python-catkin-pkg python-empy python-nose python-setuptools libgtest-dev build-essential
sudo apt-get install -y ros-indigo-catkin

source /opt/ros/indigo/setup.bash

sudo rosdep init
rosdep update
mkdir -p ~/workspace/src
cd ~/workspace/src
sudo chmod -R 777 ~/workspace/src/*
catkin_init_workspace
cd ../
catkin_make
source devel/setup.bash

echo '########## system_setup.bash  START' >> ~/.bashrc
echo source /opt/ros/indigo/setup.bash >> ~/.bashrc
echo source ~/workspace/devel/setup.bash >> ~/.bashrc
echo alias yhome="'cd ~/workspace/src/'" >> ~/.bashrc
echo export ROS_WORKSPACE_INSTALL_PATH=~/workspace/install/ >> ~/.bashrc

echo alias ymake="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ~/workspace -DCMAKE_BUILD_TYPE=Debug'" >> ~/.bashrc
echo alias ymakerelease="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ~/workspace -DCMAKE_BUILD_TYPE=Release'" >> ~/.bashrc
echo alias rmake="'cmake .. -DCMAKE_INSTALL_PREFIX:PATH=./install/ -DCMAKE_BUILD_TYPE=Debug && make -j7'" >> ~/.bashrc
echo export ROS_PACKAGE_PATH=~/workspace/src/:/opt/ros/indigo/share:$ROS_PACKAGE_PATH >> ~/.bashrc

echo '########## system_setup.bash  END' >> ~/.bashrc
source ~/.bashrc

