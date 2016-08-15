# reference 
# http://askubuntu.com/questions/466651/how-do-i-use-the-latest-gcc-on-ubuntu

sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install -y gcc-6 g++-6

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6
