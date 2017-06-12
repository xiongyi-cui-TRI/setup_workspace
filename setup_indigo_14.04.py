from os.path import expanduser
home = expanduser("~")
homeDir = home + '/'


def appendToFile(file, string):
    with open(file, "a") as myfile:
        myfile.write(string)

def appendSourceToBashrc(sourceFile):
    appendToFile(BASHRC_FILE, 'source ' + sourceFile + '\n')

def writeVecToFile(filename, vecStr):
    file = open(filename, 'w')
    for s in vecStr:
        file.write(s)
        file.write('\n')

BASHRC_FILE=homeDir+'.bashrc'
RD_PATH_FILE=homeDir+'rd_setup.sh'
RD_COMMAND_FILE=homeDir+'rd_command.sh'

# class Install_ROS:
#     ROS_PATH_FILE=homeDir+'ros_indigo_setup.sh'

#     def configDebianRepo(self):
        
#     def run(self, rosDistro):
rd_path = []
rd_path.append('export RD_ROS_WORKSPACE=~/workspace')
rd_path.append('export RD_LIB_PATH=~/library/')
rd_path.append('export RD_SYSTEM_CONFIG_DIR=/var/rd-config')
rd_path.append('export RD_LOG_DIR=/var/rd-logs')
rd_path.append('export RD_SETUP_SCRIPT_PATH=${RD_LIB_PATH}/setup_workspace')
rd_path.append('export RD_LIB_VENDOR_PATH=~/library/rdlib/')
rd_path.append('export RD_ROBOT_ROSLAUNCH_CONFIG_FILE=rd_robot_roslaunch.config')
rd_path.append('export RD_ROBOT_ROSLAUNCH_CONFIG_FILE_FULLPATH=$RD_SYSTEM_CONFIG_DIR/rd_robot_roslaunch.config')

writeVecToFile(RD_PATH_FILE, rd_path)
appendSourceToBashrc(RD_PATH_FILE)


ros_path = []
ros_path.append('export ROS_ROOT_PATH=/opt/ros/indigo/')
ros_path.append('export ROS_WORKSPACE_INSTALL_PATH=${RD_ROS_WORKSPACE}/install/')
ros_path.append('export ROS_PACKAGE_PATH=${RD_ROS_WORKSPACE}/src/:${ROS_ROOT_PATH}/share:$ROS_PACKAGE_PATH')
ros_path.append('source ${ROS_ROOT_PATH}/setup.bash')
ros_path.append('source ${RD_ROS_WORKSPACE}/devel/setup.bash')

writeVecToFile(ROS_PATH_FILE, ros_path)
appendSourceToBashrc(ROS_PATH_FILE)


rd_command = []
rd_command.append('''
function yhome()
{
cd ${RD_ROS_WORKSPACE}/src/
}\n
''')
    

writeVecToFile(RD_COMMAND_FILE, rd_command)
appendSourceToBashrc(RD_COMMAND_FILE)