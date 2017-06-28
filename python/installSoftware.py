import os
import os.path
import cmdUtil
import apt_get
import sysUtil
from plumbum.cmd import sudo
from plumbum.cmd import tee
from plumbum.cmd import echo
from plumbum.cmd import ls

# note all class here must have two method:
# config() and install()


class sublime:
    @staticmethod
    def config():
        os.system(
            'wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg \
            | sudo apt-key add -')
        os.system('echo "deb https://download.sublimetext.com/ apt/stable/" \
            | sudo tee /etc/apt/sources.list.d/sublime-text.list')

    @staticmethod
    def install():
        apt_get.apt_get_install('sublime-text')


class chrome:
    @staticmethod
    def config():
        os.system(
            "wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub \
            | sudo apt-key add -")
        os.system(
            'sudo sh -c \'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ \
            stable main" >> /etc/apt/sources.list.d/google-chrome.list\'')

    @staticmethod
    def install():
        apt_get.apt_get_install('google-chrome-stable')

class simpleRecorder:
    @staticmethod
    def config():
        os.system('sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder')

    @staticmethod
    def install():
        apt_get.apt_get_install('simplescreenrecorder')

class mono:
    @staticmethod
    def config():
        os.system(
            "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "
            "3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF")
        os.system(
            'echo "deb http://download.mono-project.com/repo/ubuntu trusty main" '
            '| sudo tee /etc/apt/sources.list.d/mono-official.list')

    @staticmethod
    def install():
        apt_get.apt_get_install('mono-devel')

class clang:
    clangVersion = '4.0'    
    @staticmethod
    def config():
        # NOTE: Not using This method, using the default Ubuntu repo to install clang 3.9
                # install clang 4.0
                # http://apt.llvm.org/
                # os.system('wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -')
                # srcDir="/etc/apt/sources.list.d/"
                # srcFile=srcDir+'clang.list'

                # if os.path.isfile(srcFile):
                #     return
                # os.system("sudo mkdir -p " + srcDir)

                # teeToSrc = 'sudo tee --append '+srcFile+''
                # if sysUtil.isUbuntu14LTS():
                #     os.system("echo 'deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-"+ \
                #         clang.clangVersion+" main\n \
                #         deb-src http://apt.llvm.org/trusty/ llvm-toolchain-trusty-"+clang.clangVersion
                #         +" main' | " + teeToSrc)
                # elif sysUtil.isUbuntu16LTS():
                #     os.system("echo 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-"+ \
                #         clang.clangVersion+" main\n \
                #         deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-"+clang.clangVersion
                #         +" main' | " + teeToSrc)

    @staticmethod
    def install():
        clang.clangVersion = '3.9'
        apt_get.apt_get_install(
            [
            'clang-'+clang.clangVersion,
            'clang-format-'+clang.clangVersion,
            'libfuzzer-'+clang.clangVersion+'-dev'
            ])
        os.system('sudo rm -rf /usr/bin/llvm-symbolizer')
        os.system('sudo ln -s /usr/bin/llvm-symbolizer-'+clang.clangVersion+' /usr/bin/llvm-symbolizer')
        # NOTE export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer
        # this is done in export_path.py

class git:
    @staticmethod
    def config():
        return 
    
    @staticmethod
    def install():

        return 

class tools:
    @staticmethod
    def config():
        return 
    
    @staticmethod
    def install():
        apt_get.apt_get_install(
        ['build-essential',
        'git',
        'gitk',
        'meld',
        'terminator',
        'htop',
        'xclip',
        'openssh-server',
        'sshpass',

        ])
        return 


# install Git-Extension
# https://github.com/gitextensions/gitextensions/releases/tag/v2.49.03

if __name__ == '__main__':
    installList = [
    sublime,
    chrome,
    mono,
    simpleRecorder,
    clang,
    tools
    ]
    for t1 in installList:
        t1.config()
    
    apt_get.apt_get_update()

    for t1 in installList:
        t1.install()
    
