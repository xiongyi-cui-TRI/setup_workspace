# install openrave binary
# http://docs.ros.org/indigo/api/moveit_tutorials/html/doc/ikfast_tutorial.html
sudo add-apt-repository "deb http://ppa.launchpad.net/openrave/testing/ubuntu trusty main"
sudo add-apt-repository "deb-src http://ppa.launchpad.net/openrave/testing/ubuntu trusty main"


# git clone –branch latest_stable https://github.com/rdiankov/openrave.git

sudo apt-get install collada-dom2.4-dp*
sudo apt-get install ros-indigo-openrave

PYTHONPATH=$PYTHONPATH:`openrave-config --python-dir`

