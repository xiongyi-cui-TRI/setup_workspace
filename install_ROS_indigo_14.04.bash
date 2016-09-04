
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
sudo apt-get install -y xclip
sudo apt-get install -y sshpass


# install gtest
cd
mkdir -p ~/library
cd ~/library
git clone https://github.com/google/googletest
cd googletest/
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/
make -j7
sudo make install

cd ~/library
git clone https://github.com/KjellKod/g3log.git
cd g3log
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_BUILD_TYPE=Release
make -j7
sudo make install



# install ros
sudo apt-get install -y ros-indigo-desktop-full
#install moveit
sudo apt-get install -y ros-indigo-moveit-full
# nlopt, needed by trac ik
sudo apt-get install -y libnlopt-dev

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
echo export RD_ROS_WORKSPACE=~/workspace >> ~/.bashrc
echo export RD_LIB_PATH=~/library/ >> ~/.bashrc
echo export RD_LIB_VENDOR_PATH=~/library/rdlib/ >> ~/.bashrc
echo export ROS_ROOT_PATH=/opt/ros/indigo/ >> ~/.bashrc

echo source ${ROS_ROOT_PATH}/setup.bash >> ~/.bashrc
echo source ${RD_ROS_WORKSPACE}/devel/setup.bash >> ~/.bashrc
echo export ROS_WORKSPACE_INSTALL_PATH=${RD_ROS_WORKSPACE}/install/ >> ~/.bashrc

echo alias yhome="'cd ${RD_ROS_WORKSPACE}/src/'" >> ~/.bashrc
echo alias ymake="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ${RD_ROS_WORKSPACE} -DCMAKE_BUILD_TYPE=Debug'" >> ~/.bashrc
echo alias ymakerelease="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ${RD_ROS_WORKSPACE} -DCMAKE_BUILD_TYPE=Release'" >> ~/.bashrc
echo alias ytest="'(yhome && cd ../build/ && ctest)'" >> ~/.bashrc

echo alias rhome="'cd ${RD_LIB_PATH}/RD_FreeCAD'" >> ~/.bashrc
echo alias rmake="'(rhome && cd build && cmake .. -DCMAKE_INSTALL_PREFIX:PATH=./install/ -DCMAKE_BUILD_TYPE=Debug && make -j7)'" >> ~/.bashrc
echo alias rmakerelease="'(rhome && cd build && cmake .. -DCMAKE_INSTALL_PREFIX:PATH=./install/ -DCMAKE_BUILD_TYPE=Release && make -j7)'" >> ~/.bashrc
echo export ROS_PACKAGE_PATH=${RD_ROS_WORKSPACE}/src/:${ROS_ROOT_PATH}/share:$ROS_PACKAGE_PATH >> ~/.bashrc
echo alias clion-keyboard-fix="'killall -9 ibus-x11'" >> ~/.bashrc
echo '########## system_setup.bash  END' >> ~/.bashrc
source ~/.bashrc
