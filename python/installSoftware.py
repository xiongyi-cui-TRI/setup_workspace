import os
import cmdUtil
import apt_get


class sublime:
    def configRepo():
        os.system(
            'wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg \
            | sudo apt-key add -')
        os.system('echo "deb https://download.sublimetext.com/ apt/stable/" \
            | sudo tee /etc/apt/sources.list.d/sublime-text.list')

    def install():
        apt_get.apt_get_install('sublime-text')


class chrome:
    def configRepo():
        os.system(
            "wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub \
            | sudo apt-key add -")
        os.system(
            'sudo sh -c \'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ \
            stable main" >> /etc/apt/sources.list.d/google-chrome.list\'')

    def install():
        apt_get.apt_get_install('google-chrome-stable')

if __name__ == '__main__':
    sublime.configRepo()
    chrome.configRepo()
    apt_get.apt_get_update()
    sublime.install()
    chrome.install()
