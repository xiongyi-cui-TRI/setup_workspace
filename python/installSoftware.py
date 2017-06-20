import os
import cmdUtil
import apt_get

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

# install Git-Extension
# https://github.com/gitextensions/gitextensions/releases/tag/v2.49.03

if __name__ == '__main__':
    sublime.config()
    chrome.config()
    mono.config()
    apt_get.apt_get_update()
    sublime.install()
    chrome.install()
    mono.install()
