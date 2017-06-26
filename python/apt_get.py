from plumbum.cmd import sudo
from plumbum.cmd import apt_get
import cmdUtil
import logging
import traceback


def apt_get_update():
    # make update command quite
    print('apt-get update')
    cmd = sudo[apt_get['-qq', 'update']] 
    ret = cmdUtil.runCmd(cmd)
    if ret[0]:
        print('    apt-get update successed')
    else:
        print('    apt-get update failed, because: ')
        print(ret[3].replace('\n', '\t\n'))
    return ret[0]


def apt_get_install(packageName):
    if isinstance(packageName, (list, tuple, set)):
        for item in packageName:
            apt_get_install(item)
    else:
        print('apt-get install '+ packageName)
        cmd = sudo[apt_get['install', '-y', packageName]]
        ret = cmdUtil.runCmd(cmd)
        if ret[0]:
            print('    apt-get install successed')
        else:
            print('    apt-get install failed, because: ')
            print(ret[3].replace('\n', '\t\n'))

        return ret[0]

