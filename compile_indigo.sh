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
rosdep install --from-paths src --ignore-src --rosdistro indigo -y

