sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> file
sudo apt-get update
sudo apt-get purge lxc-docker

sudo apt-get install -y linux-image-extra-$(uname -r)
sudo apt-get install -y apparmor
sudo apt-get install -y docker-engine
sudo usermod -aG docker $(whoami)

sudo service docker start
# run example
sudo docker run hello-world

RED='\033[0;31m'
NC='\033[0m'

# Enable UFW forwarding¶
sudo ufw status
# echo 'DEFAULT_FORWARD_POLICY="ACCEPT"' >> /etc/default/ufw
echo -e ${RED} TODO: edit /etc/default/ufw, change DEFAULT_FORWARD_POLICY="DROP"
echo -e ${RED} into DEFAULT_FORWARD_POLICY="ACCEPT" 	${NC}
sudo ufw reload
sudo ufw allow 2375/tcp


