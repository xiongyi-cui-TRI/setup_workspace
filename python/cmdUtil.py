from plumbum.cmd import sudo
from plumbum.cmd import mkdir
import logging
import traceback
import sys
# used for pretty print backtrace
import backtrace
from os.path import expanduser
import collections

backtrace.hook(
    reverse=False,
    align=False,
    strip_path=False,
    enable_on_envvar_only=False,
    on_tty=False,
    conservative=False,
    styles={})


def getHomeDir():
    return expanduser("~") + '/'


mkdirp = mkdir['-p']

#setup logging
# assuming loglevel is bound to the string value obtained from the
# command line argument. Convert to upper case to allow the user to
# specify --log=DEBUG or --log=debug
loglevel = 'INFO'
numeric_level = getattr(logging, loglevel.upper(), None)
if not isinstance(numeric_level, int):
    # log WARNING by default
    numeric_level = 20
format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
logging.basicConfig(
    filename=getHomeDir() + 'syspy.log',
    level=numeric_level,
    format=format,
    filemode='a')
# logging._defaultFormatter.converter = time.localtime
_rootLogger = logging.getLogger()

_rootLogger.setLevel(loglevel)
_ch = logging.StreamHandler(sys.stdout)
_ch.setLevel(loglevel)
formatter = logging.Formatter(format)
_ch.setFormatter(formatter)
_rootLogger.addHandler(_ch)


def logStart(log):
    log('=====================================')


# msg should be a list of string
def logError(msg):
    log = logging.error
    if isinstance(msg, collections.Sequence):
        logStart(log)
        for m in msg:
            log(m)
        logStart(log)
    else:
        log(msg)


# runCmd() will return 4-tuple of the (ifSucceeded, exit code, stdout, and stderr)
# this function is used to pretty print it
def logCmdRunSuccess(ret, cmd=None, successLog=None):
    log = logging.debug

    success = ret[0] is 0
    if not success:
        log = logging.error
    log('=====================================')
    if cmd is not None:
        log('command: %s', str(cmd))
    if success and successLog is not None:
        logging.info(successLog)

    log('return code: %d', ret[0])
    log('stdout: %s', ret[1])
    log('stderr: %s', ret[2])
    log('stack trace: \n')
    log(traceback.extract_stack())
    log('=====================================')


# return [ifReturnCodeIsZero, returnCode, stdout, stderr]
# successed, ret, stdout, stderr = buildUtil.runCmd(pwd)
# quiet -> bool , if true, log no error
def runCmd(cmd, quiet=False):
    try:
        cmdRet = cmd.run(retcode=None)
        logCmdRunSuccess(cmdRet, cmd=cmd)
    except plumbum.commands.ProcessExecutionError as err:
        ret = [False, -1, '', '']
        if quiet:
            return ret
        log = logging.error
        log('=====================================')
        log('exception thrown when run command: ')
        log(cmd)
        log('exception: ')
        log(err)
        log('stack trace: \n')
        log(traceback.extract_stack())
        log('=====================================')
        return ret

    ret = [
        True,
    ]
    ret[0] = cmdRet[0] is 0
    ret.extend(cmdRet)
    return ret


def getPWD():
    successed, ret, stdout, stderr = runCmd(pwd)
    return stdout.rstrip() + '/'


def getFileNameListAtDir(dir):
    successed, ret, stdout, stderr = runCmd(ls[dir])
    if not successed:
        return successed, []
    return successed, stdout.split()


def findFileInPathCond_FirstOnly(dir, cond):
    successed, listOfFile = getFileNameListAtDir(dir)
    ret = [False, '']
    if not successed:
        logging.fatal("can't ls dir at %s", dir)
        return ret
    for file in listOfFile:
        if cond(file):
            ret = [True, file]
            break
    else:
        logging.fatal("can't find file satisfy condition at %s", dir)
    return ret


def isSequenceContainer(var):
    return isinstance(var, collections.Sequence) and not isinstance(var, str)


def appendToFile(file, string):
    with open(file, "a") as myfile:
        if isSequenceContainer(string):
            for l in string:
                myfile.write(l)
        else:
            myfile.write(string)


def writeToFile(file, string):
    with open(file, "w") as myfile:
        if isinstance(string, collections.Sequence):
            for l in string:
                myfile.write(l + '\n')
        else:
            myfile.write(string + '\n')


def writeVecToFile(filename, vecStr):
    file = open(filename, 'w')
    for s in vecStr:
        file.write(s + '\n')
