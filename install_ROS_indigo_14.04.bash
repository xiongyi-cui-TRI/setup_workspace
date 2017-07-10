
sudo chmod -R 555 /var/log/

# get path of this script,
# ref http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
pushd `dirname $0` > /dev/null
gThisScriptPath=`pwd`
gThisScriptName=`basename "$0"`
gScriptFullName=${gScript_Path}/${gScript_Name}
popd > /dev/null

gScriptPath="$gThisScriptPath/scripts"
gInsertToFileScript="$gScriptPath/insertToFile.sh"
gInsertFunctionToBash="$gScriptPath/insertFunctionToBash.sh"
source ${gInsertToFileScript}
source ${gInsertFunctionToBash}
source ${gScriptPath}/install_ubuntu.bash

# clang debain
# newest
# sudo add-apt-repository "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty main"
# sudo add-apt-repository "deb-src http://apt.llvm.org/trusty/ llvm-toolchain-trusty main"
# clang 3.8



# sudo apt-get update
sudo apt-get install -y python-wstool
sudo apt-get install -y sshpass
sudo apt-get install -y python-setuptools
sudo apt-get install -y python-pip
sudo apt-get install -y --force-yes python3-pip
# used for python bash script
sudo pip3 install Plumbum
# used for pretty print backtrace
sudo pip3 install backtrace
# used for python code formating
sudo pip3 install yapf

# install openrave-ikfast
# reference http://docs.ros.org/jade/api/moveit_ikfast/html/doc/ikfast_tutorial.html
sudo apt-get install -y openrave0.8-dp-ikfast
insertAfterLine "/usr/lib/python2.7/dist-packages/openravepy/__init__.py" \



# sudo easy_install pip
echo '########## system_setup.bash  START' >> ~/.bashrc

# install ros
python3 python/installSoftware.py
python3 python/setup_ros_14.04.py
echo '########## system_setup.bash  END' >> ~/.bashrc
source ~/.bashrc

echo "!!!!!!!!!!!!!!!! ${RD_SETUP_SCRIPT_PATH}"


    # this step can't be done in python
    # do it here for every ros distro
    # only one of them will successed
    source /opt/ros/indigo/setup.bash
    source /opt/ros/kinetic/setup.bash


    cd ~/workspace
    catkin_make

source ~/.bashrc
cd ${RD_LIB_PATH}
echo "!!!!!!!!!!!!!!!! ${RD_SETUP_SCRIPT_PATH}"
echo "!!!!!!!!!!!!!!!! ${RD_SETUP_SCRIPT_PATH}"
echo "!!!!!!!!!!!!!!!! ${RD_SETUP_SCRIPT_PATH}"
# sh ${RD_SETUP_SCRIPT_PATH}/install_gcc6.sh
# sh ${RD_SETUP_SCRIPT_PATH}/install-vendor-library.sh
# sh ${RD_SETUP_SCRIPT_PATH}/dev/download-repo.sh
# python path problem was solved in FreeCAD
# sh ${RD_SETUP_SCRIPT_PATH}/scripts/insertToFile.sh


