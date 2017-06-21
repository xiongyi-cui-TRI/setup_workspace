from os import system
import multiprocessing
import cmdUtil
import bashrc_helper

homeDir = cmdUtil.getHomeDir()
RD_PATH_FILE = homeDir + 'rd_setup.sh'
RD_COMMAND_FILE = homeDir + 'rd_command.sh'


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

    cmdUtil.writeVecToFile(RD_PATH_FILE, rd_path)
    bashrc_helper.sourceFileInBashrc(RD_PATH_FILE)


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


def getCMakeThreadParam():
    return ' -j' + str(getMaxBuildThread())


def exportRD_Command():
    rd_command = []
    rd_command.append('# RD commands')
    rd_command.append(
        bashrc_helper.makeBashFunction('lhome', 'cd ${RD_LIB_PATH}/'))
    rd_command.append(
        bashrc_helper.makeBashFunction('rhome',
                                       'cd ${RD_LIB_PATH}/RD_FreeCAD'))
    rmakeCmd = '(rhome && cd build && cmake .. -DCMAKE_INSTALL_PREFIX:PATH=./install/ ' \
               '-DCMAKE_BUILD_TYPE={} && make ' + getCMakeThreadParam() + ' )'
    rd_command.append(
        bashrc_helper.makeBashFunction('rmake', rmakeCmd.format('Debug')))
    rd_command.append(
        bashrc_helper.makeBashFunction('rmakerelease',
                                       rmakeCmd.format('Release')))
    rd_command.append(
        bashrc_helper.makeBashFunction(
            'frmake', '(rhome && cd build && make {} -f CMakeFiles/Makefile2)'
            .format(getCMakeThreadParam())))

    rd_command.append(
        bashrc_helper.makeBashFunction('clion-keyboard-fix',
                                       'killall -9 ibus-x11'))
    rd_command.append(
        bashrc_helper.makeBashFunction('gitpruneRemote',
                                       'git fetch origin --prune'))

    rd_command.append('# this is to auto start/stop robot launch file')
    rd_command.append(
        bashrc_helper.makeBashFunction(
            'startRobotRoslaunch',
            '${RD_SETUP_SCRIPT_PATH}/dev/start-auto-roslaunch.sh start'))
    rd_command.append(
        bashrc_helper.makeBashFunction(
            'stopRobotRoslaunch',
            '${RD_SETUP_SCRIPT_PATH}/dev/start-auto-roslaunch.sh stop'))

    cmdUtil.writeVecToFile(RD_COMMAND_FILE, rd_command)
    bashrc_helper.sourceFileInBashrc(RD_PATH_FILE)
