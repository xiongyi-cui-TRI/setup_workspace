from os.path import expanduser
from os import system
import multiprocessing

home = expanduser("~")
homeDir = home + '/'
BASHRC_FILE = homeDir + '.bashrc'
RD_PATH_FILE = homeDir + 'rd_setup.sh'
RD_COMMAND_FILE = homeDir + 'rd_command.sh'


def appendToFile(file, string):
    with open(file, "a") as myfile:
        myfile.write(string)


def appendSourcingFileToBashrc(sourceFile):
    appendToFile(BASHRC_FILE, 'source ' + sourceFile + '\n')


def writeVecToFile(filename, vecStr):
    file = open(filename, 'w')
    for s in vecStr:
        file.write(s + '\n')


def exportRD_Path():
    rd_path = []
    rd_path.append('export RD_ROS_WORKSPACE=~/workspace')
    rd_path.append('export RD_LIB_PATH=~/library/')
    rd_path.append('export RD_SYSTEM_CONFIG_DIR=/var/rd-config')
    rd_path.append('export RD_LOG_DIR=/var/rd-logs')
    rd_path.append(
        'export RD_SETUP_SCRIPT_PATH=${RD_LIB_PATH}/setup_workspace')
    rd_path.append('export RD_LIB_VENDOR_PATH=~/library/rdlib/')
    rd_path.append(
        'export RD_ROBOT_ROSLAUNCH_CONFIG_FILE=rd_robot_roslaunch.config')
    rd_path.append(
        'export RD_ROBOT_ROSLAUNCH_CONFIG_FILE_FULLPATH=$RD_SYSTEM_CONFIG_DIR/rd_robot_roslaunch.config'
    )

    writeVecToFile(RD_PATH_FILE, rd_path)
    appendSourcingFileToBashrc(RD_PATH_FILE)


def getCPUCount():
    import multiprocessing
    return multiprocessing.cpu_count()


def getMaxBuildThread():
    n = getCPUCount()
    if n <= 3:
        n = 1
    elif n <= 4:
        n = 2
    else:
        n = n - 3
    return n


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
    cd ${RD_LIB_PATH}/
    }\n
    ''')

    writeVecToFile(RD_COMMAND_FILE, rd_command)
    appendSourcingFileToBashrc(RD_COMMAND_FILE)
