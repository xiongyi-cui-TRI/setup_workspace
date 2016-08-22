

# fix problem with:  Cannot set LC_CTYPE to default locale: 
# ref http://askubuntu.com/questions/162391/how-do-i-fix-my-locale-issue
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales

# problem with /usr/share/initramfs-tools/hooks/fixrtc or others
# error message: E: /usr/share/initramfs-tools/hooks/fixrtc failed with return 1
# ref https://ubuntuforums.org/showthread.php?t=2032538
chmod -x /usr/share/initramfs-tools/hooks/fixrtc

# reference http://askubuntu.com/questions/119080/how-to-update-kernel-to-the-latest-mainline-version-without-any-distro-upgrade
apt-cache search linux-image
sudo apt-get install -y linux-image-4.2.0-27-generic 
sudo apt-get install -y linux-headers-4.2.0-27-generic 
sudo apt-get install -y linux-image-extra-4.2.0-27-generic 
