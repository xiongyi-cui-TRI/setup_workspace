from os import system
import multiprocessing
import cmdUtil
from plumbum.cmd import chmod
from plumbum.cmd import sudo
from os.path import expanduser
import bashrc_helper

homeDir = cmdUtil.getHomeDir()
RD_PATH_FILE = homeDir + 'rd_setup.sh'
RD_COMMAND_FILE = homeDir + 'rd_command.sh'


def setup_rd_dir(dir, setPermission=False, useSudoIfNecessary=True):
    cmd = cmdUtil.mkdirp[dir]
    ret = cmdUtil.runCmd(cmd, quiet=True)
    if ret[0]:
        print('created dir: ' + dir)

    elif 'Permission denied' in ret[3] and useSudoIfNecessary:
        # sudo mkdir
        cmd = sudo[cmdUtil.mkdirp[dir]]
        ret = cmdUtil.runCmd(cmd)
        if ret[0]:
            print('created dir: ' + dir)
            if setPermission:
                cmd = chmod['777', dir]
                ret = cmdUtil.runCmd(cmd)
    else:
        # not using sudo mkdir
        # log error by rerun mkdir without quiet
        cmd = cmdUtil.mkdirp[dir]
        ret = cmdUtil.runCmd(cmd)



def exportRD_Path():
    rd_path = []
    wsDir = '~/workspace'
    wsDirExp = expanduser(wsDir)
    setup_rd_dir(wsDirExp)
    rd_path.append('export RD_ROS_WORKSPACE=' + wsDir)
    rd_path.append('export RD_LIB_PATH=~/library/')

    # create config dir
    configDir = '/var/rd-config'
    rd_path.append('export RD_SYSTEM_CONFIG_DIR=' + configDir)
    setup_rd_dir(configDir, True)
    # create log dir
    logDir = '/var/rd-log'
    rd_path.append('export RD_LOG_DIR=' + logDir)
    setup_rd_dir(logDir, True)

    rd_path.append(
        'export RD_SETUP_SCRIPT_PATH=${RD_LIB_PATH}/setup_workspace')
    rd_path.append('export RD_LIB_VENDOR_PATH=~/library/rdlib/')
    rd_path.append(
        'export RD_ROBOT_ROSLAUNCH_CONFIG_FILE=rd_robot_roslaunch.config')
    rd_path.append(
        'export RD_ROBOT_ROSLAUNCH_CONFIG_FILE_FULLPATH=$RD_SYSTEM_CONFIG_DIR/rd_robot_roslaunch.config'
    )
    rd_path.append('\n# This is used by clang\n \
        export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer')

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
               '-DCMAKE_BUILD_TYPE=%s && make ' + getCMakeThreadParam() + ' )'
    rd_command.append(
        bashrc_helper.makeBashFunction('rmake', rmakeCmd % 'Debug'))
    rd_command.append(
        bashrc_helper.makeBashFunction('rmakerelease', rmakeCmd % 'Release'))
    rd_command.append(
        bashrc_helper.makeBashFunction(
            'frmake', '(rhome && cd build && make %s -f CMakeFiles/Makefile2)'
            % getCMakeThreadParam()))

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
    bashrc_helper.sourceFileInBashrc(RD_COMMAND_FILE)
