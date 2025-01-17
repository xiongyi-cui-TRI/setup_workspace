#sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update

sudo apt-get install -y git vim htop gitk sublime-text gnome-tweak-tool

# add git log prettifier
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

sudo apt-get install -y python3-pip python3-venv python3-yapf python3-tk

mkdir -p ~/workspace
cd ~/workspace
python3 -m venv dl_env 

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --update-rc

# put setup script into .bashrc
echo "# xiongyi workspace setup script start----------
        # record command history, avoid duplicates
        export HISTCONTROL=ignoredups:erasedups  
        # When the shell exits, append to the history file instead of overwriting it
        shopt -s histappend

        # After each command, append to the history file and reread it
        export PROMPT_COMMAND=\"\${PROMPT_COMMAND:+\$PROMPT_COMMAND$'\\n'}history -a; history -c; history -r\"
        function activate_dl_env 
        {
                source ~/workspace/dl_env/bin/activate
        }
# xiongyi workspace setup script end----------
" | tee -a ~/.bashrc

# install libraries in venv
source ~/workspace/dl_env/bin/activate
pip3 install torch torchvision numpy scipy matplotlib ipython jupyter pandas tensorboardX pyyaml pycocotools pyrealsense2 pytransform3d cython pycocotools
