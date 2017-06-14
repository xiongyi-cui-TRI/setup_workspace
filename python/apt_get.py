from plumbum.cmd import sudo
from plumbum.cmd import apt_get
import cmdUtil
import logging
import traceback


def apt_get_install(packageName):
    if isinstance(packageName, (list, tuple, set)):
        for item in packageName:
            apt_get_install(item)
    else:
        cmd = sudo[apt_get['install', '-y', packageName]]
        ret = cmd.run()
        cmdUtil.printCmdRunReturn(
            ret, cmd, successLog='installed package ' + packageName)
