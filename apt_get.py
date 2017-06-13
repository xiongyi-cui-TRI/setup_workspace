from plumbum.cmd import sudo
from plumbum.cmd import apt_get
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
loglevel = 'WARNING'
numeric_level = getattr(logging, loglevel.upper(), None)
if not isinstance(numeric_level, int):
	# log WARNING by default
    numeric_level = 30
logging.basicConfig(filename='setup.log',level=numeric_level, format='%(asctime)s %(message)s',\
	filemode='a')

# command.run() will return 3-tuple of the (exit code, stdout, and stderr)
# this function is used to pretty print it
def printCmdRunReturn(ret, cmd=None):
	log = logging.debug
	if ret[0] is not 0:
		log = logging.warning
	log = logging.warning
	log('=====================================')
	if cmd is not None:
		log('command: %s', str(cmd))
	log('return code: %d', ret[0])
	log('stdout: %s', ret[1])
	log('stderr: %s', ret[2])
	log('stack brace: \n')
	log(traceback.extract_stack())
	log('=====================================')


def apt_get_install(packageName):
	cmd = sudo[apt_get['install', '-y', packageName]]
	ret = cmd.run()
	printCmdRunReturn(ret, cmd)

apt_get_install('vim')