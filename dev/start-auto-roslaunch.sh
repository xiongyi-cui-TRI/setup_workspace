

function getAutoStartRoslaunch_PID
{
	local ret=`ps aux | grep "python" | grep "autoStartRobotRoslaunchFile.py"| awk {'print $2'}`
  	echo $ret
}
function Command_To_Launch_AutoStartRoslaunch
{
	`(python $RD_SETUP_SCRIPT_PATH/dev/autoStartRobotRoslaunchFile.py >> $RD_LOG_DIR/autoStartRobotRoslaunch.log ) &`
}

# function checkExist_AutoStartRoslaunch
# {

# }



# init
gParam=$1
gAutoStartPID=$(getAutoStartRoslaunch_PID)
echo "pid of AutoStartRoslaunch_PID:  $gAutoStartPID"

# main
if [[ $gParam == 'stop' ]]; then 
	if [[ ! -z $gAutoStartPID ]]; then
		echo "killing process of $gAutoStartPID"
		kill -SIGTERM $gAutoStartPID	
		sleep 0.3s
	fi
	newPID=$(getAutoStartRoslaunch_PID)
	echo "Now process PID: $newPID"
elif [[ $gParam == 'start' ]]; then
	if [[ -z $gAutoStartPID ]]; then
	  	echo 'no AutoStartRoslaunch found, launching'
	    `Command_To_Launch_AutoStartRoslaunch`
	else
		echo "already running at PID: $gAutoStartPID"
	fi
else
	echo "option: start or stop"
fi

