#!/bin/bash

## echo commands to terminal
set -x

######################################
## update package manager and get some required packages
apt-get update
apt install software-properties-common
add-apt-repository universe -y
apt-get update
apt-get install -y curl tcsh sudo ffmpeg

######################################
## get the admin script for the afni install
curl -O https://raw.githubusercontent.com/afni/afni/master/src/other_builds/OS_notes.linux_ubuntu_24_64_a_admin.txt
bash OS_notes.linux_ubuntu_24_64_a_admin.txt

######################################
## make folders and links for mounting local host drives and local syncs
mkdir -p /home/external/
chown -R afni_user:afni_user /home/afni_user/
chown -R afni_user:afni_user /home/external/

## ( -h for symbolic link )
ln -s /home/external/.afnirc /home/afni_user/.afnirc
chown -h afni_user:afni_user /home/afni_user/.afnirc
