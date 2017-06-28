sudo apt-get install -y git
mkdir -p ~/library
cd ~/library
git clone https://github.com/cuixiongyi/setup_workspace.git
cd setup_workspace
git checkout use_py
./install_ROS_indigo_14.04.bash
