from os.path import expanduser
from os import system

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
        file.write(s+'\n')

def exportRD_Path():
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

def exportRD_Command():
    rd_command = []
    rd_command.append('''
    function yhome()
    {
    cd ${RD_ROS_WORKSPACE}/src/
    }\n
    ''')

    rd_command.append('''
    function  lhome()
    {
    cd ${RD_LIB_PATH}/src/
    }
    ''')

    writeVecToFile(RD_COMMAND_FILE, rd_command)
    appendSourceToBashrc(RD_COMMAND_FILE)