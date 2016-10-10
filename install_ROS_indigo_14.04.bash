
sudo chmod -R 555 /var/log/

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
sudo apt-get install python-setuptools
sudo easy_install pip

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

exportPath()
{
	eval $@
	echo $@ >> ~/.bashrc
}

exportRD_ROS_WORKSPACE='export RD_ROS_WORKSPACE=~/workspace'
exportPath $exportRD_ROS_WORKSPACE
exportRD_LIB_PATH='export RD_LIB_PATH=~/library/'
exportPath $exportRD_LIB_PATH
mkdir -p $RD_LIB_PATH

exportRD_SETUP_SCRIPT_PATH='export RD_SETUP_SCRIPT_PATH=${RD_LIB_PATH}/setup_workspace'
exportPath $exportRD_SETUP_SCRIPT_PATH

exportRD_LIB_VENDOR_PATH='export RD_LIB_VENDOR_PATH=~/library/rdlib/'
exportPath $exportRD_LIB_VENDOR_PATH

exportROS_ROOT_PATH='export ROS_ROOT_PATH=/opt/ros/indigo/'
exportPath $exportROS_ROOT_PATH

exportROS_WORKSPACE_INSTALL_PATH='export ROS_WORKSPACE_INSTALL_PATH=${RD_ROS_WORKSPACE}/install/'
exportPath $exportROS_WORKSPACE_INSTALL_PATH

exportROS_PACKAGE_PATH='export ROS_PACKAGE_PATH=${RD_ROS_WORKSPACE}/src/:${ROS_ROOT_PATH}/share:$ROS_PACKAGE_PATH'
exportPath $exportROS_PACKAGE_PATH

exportRD_SYSTEM_CONFIG_DIR='export RD_SYSTEM_CONFIG_DIR=/var/rd-config'
exportPath $exportRD_SYSTEM_CONFIG_DIR
sudo mkdir -p $RD_SYSTEM_CONFIG_DIR
sudo chmod 777 -R $RD_SYSTEM_CONFIG_DIR

exportRD_ROBOT_ROSLAUNCH_CONFIG_FILE='export RD_ROBOT_ROSLAUNCH_CONFIG_FILE=rd_robot_roslaunch.config'
exportRD_ROBOT_ROSLAUNCH_CONFIG_FILE_FULLPATH='export RD_ROBOT_ROSLAUNCH_CONFIG_FILE_FULLPATH=$RD_SYSTEM_CONFIG_DIR/rd_robot_roslaunch.config'
exportPath $exportRD_ROBOT_ROSLAUNCH_CONFIG_FILE
exportPath $exportRD_ROBOT_ROSLAUNCH_CONFIG_FILE_FULLPATH

echo '########## system_setup.bash  START' >> ~/.bashrc

echo source ${ROS_ROOT_PATH}/setup.bash >> ~/.bashrc
echo source ${RD_ROS_WORKSPACE}/devel/setup.bash >> ~/.bashrc

echo alias yhome="'cd ${RD_ROS_WORKSPACE}/src/'" >> ~/.bashrc
echo alias ymake="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ${RD_ROS_WORKSPACE} -DCMAKE_BUILD_TYPE=Debug'" >> ~/.bashrc
echo alias ymakerelease="'catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH -C ${RD_ROS_WORKSPACE} -DCMAKE_BUILD_TYPE=Release'" >> ~/.bashrc
echo alias ytest="'(yhome && cd ../build/ && ctest)'" >> ~/.bashrc

echo alias rhome="'cd ${RD_LIB_PATH}/RD_FreeCAD'" >> ~/.bashrc
echo alias rmake="'(rhome && cd build && cmake .. -DCMAKE_INSTALL_PREFIX:PATH=./install/ -DCMAKE_BUILD_TYPE=Debug && make -j7)'" >> ~/.bashrc
# fast rmake do not reconfig cmake, will not work if add new files or any changes to cmake
echo alias frmake="'(rhome && cd build && make -j7 -f CMakeFiles/Makefile2)'" >> ~/.bashrc
echo alias rmakerelease="'(rhome && cd build && cmake .. -DCMAKE_INSTALL_PREFIX:PATH=./install/ -DCMAKE_BUILD_TYPE=Release && make -j7)'" >> ~/.bashrc
echo alias clion-keyboard-fix="'killall -9 ibus-x11'" >> ~/.bashrc
echo alias gitpruneRemote="'git fetch origin --prune'" >> ~/.bashrc
echo alias startRobotRoslaunch="'././${RD_SETUP_SCRIPT_PATH}/dev/start-auto-roslaunch.sh'" >> ~/.bashrc
echo '########## system_setup.bash  END' >> ~/.bashrc
source ~/.bashrc

cd ${RD_LIB_PATH}
git clone https://github.com/cuixiongyi/setup_workspace.git
./${RD_SETUP_SCRIPT_PATH}/install-vendor-library.sh
./${RD_SETUP_SCRIPT_PATH}/dev/download-repo.sh

