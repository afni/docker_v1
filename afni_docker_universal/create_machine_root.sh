#!/bin/bash

## echo commands to terminal
set -x

######################################
## update package manager and get some required packages
apt-get update
apt install -y software-properties-common
add-apt-repository universe -y
apt-get update
apt-get install -y curl tcsh sudo ffmpeg iputils-ping wget

######################################
## get the admin script for the afni install
curl -O https://raw.githubusercontent.com/afni/afni/master/src/other_builds/OS_notes.linux_ubuntu_24_64_a_admin.txt
bash OS_notes.linux_ubuntu_24_64_a_admin.txt

######################################
## firefox complicated install because of snap
apt-get remove -y firefox

sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt-get update && sudo apt-get install -y firefox


######################################
## make folders and links for mounting local host drives and local syncs
mkdir -p /usr/local/abin
chown -R afni_user:afni_user /usr/local/abin
mkdir -p /home/external/
mkdir -p /home/afni_user/
chown -R afni_user:afni_user /home/afni_user/
chown -R afni_user:afni_user /home/external/

## ( -h for symbolic link )
ln -s /home/external/.afnirc /home/afni_user/.afnirc
chown -h afni_user:afni_user /home/afni_user/.afnirc
