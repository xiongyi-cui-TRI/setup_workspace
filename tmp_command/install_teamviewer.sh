
# add Multiarch
sudo dpkg --add-architecture i386
sudo apt-get update

# download teamviewer_*_amd64.deb 
# https://www.teamviewer.com/en/help/363-How-do-I-install-TeamViewer-on-my-Linux-distribution.aspx
# search for For 64-bit DEB-systems without Multiarch
sudo dpkg -i teamviewer_11.0.57095_amd64.deb 
sudo apt-get install -f

