from export_path import *
from apt_get import *
from cmdUtil import *
import backtrace

backtrace.hook(
    reverse=False,
    align=False,
    strip_path=False,
    enable_on_envvar_only=False,
    on_tty=False,
    conservative=False,
    styles={})


BASHRC_FILE=homeDir+'.bashrc'
RD_PATH_FILE=homeDir+'rd_setup.sh'
RD_COMMAND_FILE=homeDir+'rd_command.sh'

class Install_ROS:
    def __init__(self):

    def configDebianRepo(self):
        # this two are the same, at least for indigo and Kinetic
        os.system("sudo sh -c 'echo \"deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main\"\
         > /etc/apt/sources.list.d/ros-latest.list'")
        os.system("sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
            --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116")
        os.system("sudo apt-get update")

    # rosDistro is ros distribution name (lower case), indigo, kinetic 
    def run(self, rosDistro='indigo'):
        self.rosDistro = rosDistro
        self.ROS_PATH_FILE=homeDir+'ros_'+rosDistro+'_setup.sh'
        self.configDebianRepo()
        apt_get_install('ros-'+rosDistro+'-desktop') # ros-indigo-desktop
        apt_get_install('ros-'+rosDistro+'-desktop')
        apt_get_install('ros-'+rosDistro+'-shape-msgs') # ros-indigo-shape-msgs
        apt_get_install('ros-'+rosDistro+'-visualization-msgs') # ros-indigo-visualization-msgs
        apt_get_install('ros-'+rosDistro+'-moveit-full') # ros-indigo-moveit-full
        apt_get_install('ros-'+rosDistro+'-tf2-geometry-msgs') # ros-indigo-tf2-geometry-msgs
        apt_get_install('ros-'+rosDistro+'-catkin') # ros-indigo-catkin
        apt_get_install('ros-'+rosDistro+'-catkin') # ros-indigo-catkin
        packList = 'python-catkin-pkg python-empy python-nose python-setuptools'.split()
        selc.exportROS_Path(packList)

    def exportROS_Path(self):
        ros_path = []
        ros_path.append('export ROS_ROOT_PATH=/opt/ros/'+self.rosDistro+'/')
        ros_path.append('export ROS_WORKSPACE_INSTALL_PATH=${RD_ROS_WORKSPACE}/install/')
        ros_path.append('export ROS_PACKAGE_PATH=${RD_ROS_WORKSPACE}/src/:${ROS_ROOT_PATH}/share:$ROS_PACKAGE_PATH')
        ros_path.append('source ${ROS_ROOT_PATH}/setup.bash')
        ros_path.append('source ${RD_ROS_WORKSPACE}/devel/setup.bash')

        writeVecToFile(self.ROS_PATH_FILE, ros_path)
        appendSourceToBashrc(self.ROS_PATH_FILE)

def main()
    ins = Install_ROS()
    ins.run()

if __name__ == "__main__":
    main()

