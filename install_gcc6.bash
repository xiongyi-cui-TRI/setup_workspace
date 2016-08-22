# reference 
# http://askubuntu.com/questions/466651/how-do-i-use-the-latest-gcc-on-ubuntu
sudo apt-get install -y software-properties-common

sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install -y gcc-6 g++-6

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

# add alternative for 4.8
# sudo apt-get install gcc-4.8 g++-4.8
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8

# choose alternative
# sudo update-alternatives --config gcc
