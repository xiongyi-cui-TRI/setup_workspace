
sudo apt-get install -y pbzip2 

# compress tar.bz2 as default, fast and small

sudo tar cf ros_workspace.tar.bz2 --use-compress-prog=pbzip2  ros_workspace/

# extract
sudo tar xf ros_workspace.tar.bz2 --use-compress-prog=pbzip2