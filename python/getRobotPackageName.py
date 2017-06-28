import cmdUtil
from plumbum.cmd import rospack

def getRobotPackageName():
	cmd = rospack['list']
	ret = cmdUtil.runCmd(cmd)
    if not ret[0]:
    	return []
	stdout = ret[2]
	packs = stdout.split('\n')
	robotPackages = []
	for pack in packs:
		# pack example:
		# kuka_110_moveit_config /opt/ros/indigo/share/kuka_110_moveit_config
		moveitSuffix = '_moveit_config'
		if moveitSuffix in pack:
			# packName example:
			# kuka_110
			packName = pack.split(' ')[0].replace(moveitSuffix, '')
			candidate = packName
			if '\n'+candidate+' ' in stdout:
				robotPackages.append(candidate)
	return robotPackages







