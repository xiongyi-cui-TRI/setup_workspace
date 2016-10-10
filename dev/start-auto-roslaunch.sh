function getAutoStartRoslaunch_PID
{
	local res=`ps aux | grep "python" | grep "autoStartRobotRoslaunchFile.py"| awk {'print $2'}`
  	echo $res
}
function Command_To_Launch_AutoStartRoslaunch
{
	`(python $RD_SETUP_SCRIPT_PATH/dev/autoStartRobotRoslaunchFile.py >> $RD_LOG_DIR/autoStartRobotRoslaunch.log ) &`
}

autoStartPID=$(getAutoStartRoslaunch_PID)
echo "pid of AutoStartRoslaunch_PID:  $autoStartPID"
if [ -z $autoStartPID ]
  then
  	echo 'no AutoStartRoslaunch found, launching'
    `Command_To_Launch_AutoStartRoslaunch`
else
	echo "already running at PID: $autoStartPID"
fi


