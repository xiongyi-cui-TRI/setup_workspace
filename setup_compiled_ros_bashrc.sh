
mkdir -p ~/workspace/src

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

ROS_SETUP_BASH=~/ros_workspace/install_isolated/setup.bash

# source compiled ROS
source $ROS_SETUP_BASH


echo '########## system_setup.bash  START' >> ~/.bashrc
echo ROS_SETUP_BASH=~/ros_workspace/install_isolated/setup.bash >> ~/.bashrc
#echo source /opt/ros/indigo/setup.bash >> ~/.bashrc
echo source $ROS_SETUP_BASH >> ~/.bashrc
echo alias yhome="'cd ~/workspace/src/'" >> ~/.bashrc
echo export ROS_WORKSPACE_INSTALL_PATH=~/workspace/install/ >> ~/.bashrc
echo export ROS_ROOT_PATH=$ROS_ROOT >> ~/.bashrc

alias ytest='yhome && cd ../build/ && ctest'

echo alias ymake="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ~/workspace -DCMAKE_BUILD_TYPE=Debug'" >> ~/.bashrc
echo alias ymakerelease="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ~/workspace -DCMAKE_BUILD_TYPE=Release'" >> ~/.bashrc
echo alias ytest="''yhome && cd ../build/ && ctest''" >> ~/.bashrc
echo alias rmake="'cmake .. -DCMAKE_INSTALL_PREFIX:PATH=./install/ -DCMAKE_BUILD_TYPE=Debug && make -j7'" >> ~/.bashrc
echo export ROS_PACKAGE_PATH=~/workspace/src/:/opt/ros/indigo/share:$ROS_PACKAGE_PATH >> ~/.bashrc
echo alias clion-keyboard-fix="'killall -9 ibus-x11'" >> ~/.bashrc
echo '########## system_setup.bash  END' >> ~/.bashrc
source ~/.bashrc