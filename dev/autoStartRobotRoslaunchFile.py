# Warning!! do not change the name of this file,
#   name is used in start-ros-launch.sh

# Warning!! do NOT start this directly, 
#   if there are multiple instance of this file running,
#   the roslaunch file will auto stop and start like crazy

from threading import Thread
import subprocess
from time import sleep
import signal
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler  
import os
import sys

g_RD_Robot_Roslaunch_Config_Dir = os.environ['RD_SYSTEM_CONFIG_DIR']
g_RD_Robot_Roslaunch_Config_File = os.environ['RD_ROBOT_ROSLAUNCH_CONFIG_FILE']
g_RD_Robot_Roslaunch_Config_File_FullPath = os.environ['RD_ROBOT_ROSLAUNCH_CONFIG_FILE_FULLPATH']
g_roslaunch_Process = None

g_SIGNALS_TO_NAMES_DICT = dict((getattr(signal, n), n) \
    for n in dir(signal) if n.startswith('SIG') and '_' not in n )

def ternimateg_roslaunch():
    global g_roslaunch_Process
    if g_roslaunch_Process is not None:
        # only terminate when poll() return None, which means it's still running
        if g_roslaunch_Process.poll() is None:
            print('terminate roslaunch process')
            g_roslaunch_Process.terminate()

def signal_handler(signal, frame):
    global g_SIGNALS_TO_NAMES_DICT
    ternimateg_roslaunch()
    print('####Robot_Auto_Roslaunch signal recived: ', g_SIGNALS_TO_NAMES_DICT[signal])
    sys.exit(0)

signal.signal(signal.SIGTERM, signal_handler)
signal.signal(signal.SIGINT, signal_handler)


def readConfigFile():
    global g_RD_Robot_Roslaunch_Config_File_FullPath
    lines = None
    with open(g_RD_Robot_Roslaunch_Config_File_FullPath) as f:
        lines = f.readlines()[0].replace('\n', '').split(' ')
    print('####Reading config from ', g_RD_Robot_Roslaunch_Config_File_FullPath, ', \ncontent: ', lines)
    return lines

def lanuchRoslaunch():
    global g_roslaunch_Process
    ternimateg_roslaunch()
    launchFileName = readConfigFile()
    args = ["roslaunch"]
    args.extend(launchFileName)
    print('####launching subprocess with command line = ', args)
    g_roslaunch_Process = subprocess.Popen(args)

def tryLanuchRoslaunch():
    global g_roslaunch_Process
    if g_roslaunch_Process is None:
        print('####launch roslaunch from None')
        lanuchRoslaunch()
    # g_roslaunch_Process.poll() return None if subprocess is still alive
    elif g_roslaunch_Process.poll() is not None:
        print('####restarting roslaunch')
        lanuchRoslaunch()


class MyFileChangeHandler(FileSystemEventHandler):

    
    def on_modified(self, event):
        global g_roslaunch_Process
        global g_RD_Robot_Roslaunch_Config_File_FullPath
        print("####file changed detected: ", event.src_path, event.event_type)  # print now only for degug
        if event.src_path == g_RD_Robot_Roslaunch_Config_File_FullPath:
            print('#######on launch config change roslaunch')
            lanuchRoslaunch()

if __name__ == "__main__":
    event_handler = MyFileChangeHandler()
    observer = Observer()
    print('####config path = ', g_RD_Robot_Roslaunch_Config_Dir)
    observer.schedule(event_handler, path=g_RD_Robot_Roslaunch_Config_Dir, recursive=False)
    tryLanuchRoslaunch()
    observer.start()
    try:
        while True:
            time.sleep(3)
            # print('### poll value: ', g_roslaunch_Process.poll())
            tryLanuchRoslaunch()
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

    ternimateg_roslaunch()

    # process_1 = subprocess.Popen(["roslaunch", "abb_irb6400_moveit_confignonEndEffector", "demolite.launch"])
    # sleep(5)
    # print("thread status-------", thread.is_alive())
    # process_1.terminate()
    print("finisheddddddddddddd...exiting")