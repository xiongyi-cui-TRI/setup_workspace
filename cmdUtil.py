from plumbum.cmd import sudo
from plumbum.cmd import mkdir
import logging
import traceback
import sys
# used for pretty print backtrace
import backtrace

backtrace.hook(
    reverse=False,
    align=False,
    strip_path=False,
    enable_on_envvar_only=False,
    on_tty=False,
    conservative=False,
    styles={})

#setup logging
# assuming loglevel is bound to the string value obtained from the
# command line argument. Convert to upper case to allow the user to
# specify --log=DEBUG or --log=debug
loglevel = 'INFO'
numeric_level = getattr(logging, loglevel.upper(), None)
if not isinstance(numeric_level, int):
	# log WARNING by default
    numeric_level = 20
logging.basicConfig(filename='setup.log',level=numeric_level, format='%(asctime)s %(message)s',\
	filemode='a')

# command.run() will return 3-tuple of the (exit code, stdout, and stderr)
# this function is used to pretty print it
def printCmdRunReturn(ret, cmd=None, successLog=None, failLog=None):
    log = logging.debug
    
    success = ret[0] is 0
    if success:
        log = logging.error
    log('=====================================')
    if cmd is not None:
        log('command: %s', str(cmd))
    if success and successLog is not None:
        logging.info(successLog)
    elif not success and failLog is not None:
        logging.info(failLog)

    log('return code: %d', ret[0])
    log('stdout: %s', ret[1])
    log('stderr: %s', ret[2])
    log('stack brace: \n')
    log(traceback.extract_stack())
    log('=====================================')


mkdirp = mkdir['-p']
