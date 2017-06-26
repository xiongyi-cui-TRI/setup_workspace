import os
import export_path
import apt_get
import cmdUtil
from plumbum.cmd import ls
import backtrace
import bashrc_helper
backtrace.hook(
    reverse=False,
    align=False,
    strip_path=False,
    enable_on_envvar_only=False,
    on_tty=False,
    conservative=False,
    styles={})


class Install_ROS:
    def __init__(self, rosDistro='indigo'):
        self.rosDistro = rosDistro
        homeDir = cmdUtil.getHomeDir()
        self.ROS_PATH_FILE = homeDir + 'ros_setup.sh'
        self.ROS_COMMAND_FILE = homeDir + 'ros_command.sh'
        a = 1

    # this repo config are the same, at least for indigo and Kinetic
    def configDebianRepo(self, forceAptgetUpdate=False):
        repoFile = '/etc/apt/sources.list.d/ros-latest.list'
        try:
            # if the file exist do nothing
            ls[repoFile].run()
        except:
            print('cant find ros repo file '+repoFile)
            # if the file doens't exist, create file and update
            os.system(
                "sudo sh -c 'echo \"deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main\" > "
                + repoFile + "'")
            os.system(
                "sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
                --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116")
            apt_get.apt_get_update()
        if forceAptgetUpdate:
            apt_get.apt_get_update()

    # rosDistro is ros distribution name (lower case), indigo, kinetic
    def run(self):
        self.configDebianRepo()

        # ros-indigo-
        rosPrefix = 'ros-' + self.rosDistro + '-'

        
        rosPackages=[
        # ros-indigo-desktop-full
        rosPrefix + 'desktop-full',
        rosPrefix + 'desktop',
        rosPrefix + 'shape-msgs',
        # ros-indigo-visualization-msgs
        rosPrefix + 'visualization-msgs',
        # ros-indigo-moveit-full
        rosPrefix + 'moveit-full',
        # ros-indigo-tf2-geometry-msgs
        rosPrefix + 'tf2-geometry-msgs',
        # ros-indigo-catkin
        rosPrefix + 'catkin',
        'python-catkin-pkg',
        'python-empy',
        'python-nose',
        'python-setuptools'
        ] 
        apt_get.apt_get_install(rosPackages)
        self.exportROS_Path()
        self.exportROS_bashCommand()

    def exportROS_Path(self):
        export_path.exportRD_Path()
        ros_path = []
        ros_path.append('# ROS EVN')
        ros_path.append(
            'export ROSCONSOLE_FORMAT=\'[${severity}] [${time} ${file} ${line}]: ${message}\''
        )

        ros_path.append('# ROS path: \n')

        ros_path.append('export ROS_ROOT_PATH=/opt/ros/' + self.rosDistro +
                        '/')
        ros_path.append(
            'export ROS_WORKSPACE_INSTALL_PATH=${RD_ROS_WORKSPACE}/install/')
        ros_path.append(
            'export ROS_PACKAGE_PATH=${RD_ROS_WORKSPACE}/src/:${ROS_ROOT_PATH}/share:$ROS_PACKAGE_PATH'
        )
        ros_path.append('source ${ROS_ROOT_PATH}/setup.bash')
        ros_path.append('source ${RD_ROS_WORKSPACE}/devel/setup.bash')

        cmdUtil.writeVecToFile(self.ROS_PATH_FILE, ros_path)
        bashrc_helper.sourceFileInBashrc(self.ROS_PATH_FILE)

    def exportROS_bashCommand(self):
        export_path.exportRD_Command()
        ros_command = []
        ros_command.append('# ROS commands: \n')
        ros_command.append(
            bashrc_helper.makeBashFunction('yhome',
                                           'cd ${RD_ROS_WORKSPACE}/src/'))

        ymakeCommand='catkin_make install -DCMAKE_INSTALL_PREFIX:PATH=$ROS_WORKSPACE_INSTALL_PATH ' \
                     '-C ${RD_ROS_WORKSPACE} -DCMAKE_BUILD_TYPE=%s' +export_path.getCMakeThreadParam()
        ros_command.append(
            bashrc_helper.makeBashFunction('ymake',
                                           ymakeCommand % 'Debug'))
        ros_command.append(
            bashrc_helper.makeBashFunction('ymakerelease',
                                           ymakeCommand % 'Release'))

        ros_command.append(
            bashrc_helper.makeBashFunction('ytest',
                                           '(yhome && cd ../build/ && ctest)'))
        cmdUtil.writeVecToFile(self.ROS_COMMAND_FILE, ros_command)
        bashrc_helper.sourceFileInBashrc(self.ROS_COMMAND_FILE)


def main():
    ins = Install_ROS()
    ins.run()


if __name__ == "__main__":
    main()
