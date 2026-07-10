#! /bin/bash

# Description: This script is to update the base OS installation and install basic apps/commands not included with the CentOS 6 minimal distro.

# Use: this script should be used as the setup process upon first installing Centos 6 minimal and loggin in via CLI.

# Run script as root unless instructed otherwise.


echo "Updating all yum pacakges..."
yum update -y
echo "----------------------------"
echo "UPDATES DONE!"
echo "----------------------------"


echo "Installing 'man' pages..."
yum install man.x86_64 -y
echo "----------------------------"
echo "MAN PAGES INSTALLED!"
echo "----------------------------"


echo "Installing VIM..."
yum install vim -y
echo "----------------------------"
echo "VIM INSTALLED!"
echo "----------------------------"


echo "Installing 'nslookup' command..."
yum install bind-utils -y
echo "----------------------------"
echo "NSLOOKUP COMMAND INSTALLED!"
echo "----------------------------"


echo "Installing zsh shell..."
yum install zsh.x86_64 -y
echo "----------------------------"
echo "ZSH SHELL INSTALLED!"
echo "----------------------------"


echo "Installing 'wget' command..."
yum install wget.x86_64 -y
echo "----------------------------"
echo "WGET COMMAND INSTALLED!"
echo "----------------------------"


echo "Installing 'curl' command..."
yum install curl.x86_64 -y
echo "----------------------------"
echo "CURL COMMAND INSTALLED!"
echo "----------------------------"


echo "Installing Python-3.4..."
yum install python34.x86_64 -y
echo "----------------------------"
echo "PYTHON3.4 INSTALLED!"
echo "----------------------------"


echo "Installing epel-release repo..."
yum install epel-release -y
echo "----------------------------"
echo "EPEL-RELEASE REPO INSTALLED!"
echo "---------------------------"

echo "Installing Desktop GUI environment..."
yum groupinstall "Desktop" "Desktop Platform" "X Window System" "Fonts" -y 
echo "----------------------------"
echo "DESKTOP GUI ENVIRONMENT INSTALLED!"
echo "----------------------------"

echo "#ATTENTION!!!: PLEASE ENABLE 'GNOME'"
echo "#INSTRUCTIONS:"
echo "#1 - Open /etc/inittab file."
echo "#2 - Change the line 'id:3:initdefault:' to 'id:5:initdefault:' "
echo "-TIP: It's better if you comment out the original id:3 line and add the new one below"
echo "#3 - Reboot machine and finish setup in GUI mode."
echo "----REBOOT MACHINE----" 
