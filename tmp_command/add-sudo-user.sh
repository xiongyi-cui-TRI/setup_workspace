
# usage 
# addSudoUser xiongyi

function addSudoUser
{
	local username="$1" 
	sudo adduser $username
	sudo usermod -aG sudo $username
	su - $username
}

addSudoUser $1