from plumbum.cmd import sudo
from plumbum.cmd import apt_get
import logging
import traceback




def apt_get_install(packageName):
	if packageName isinstance(lst):
		for item in packageName:
			apt_get_install(item)
	else 
		cmd = sudo[apt_get['install', '-y', packageName]]
		ret = cmd.run()
		printCmdRunReturn(ret, cmd, successLog='installed package '+packageName)


