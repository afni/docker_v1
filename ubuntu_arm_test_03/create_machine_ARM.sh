#!/bin/sh

##############################
## This file is a duplicate of this one in the afni GitHub repo:
##   src/other_builds/OS_notes.linux_ubuntu_24_64_a_admin.txt
## NB: the 'sudo ..' part of each has been removed


######################################
## update package manager and get some required packages
add-apt-repository universe -y
apt-get update
apt-get install -y curl csh tcsh sudo ffmpeg

######################################
## get the admin script for the afni install
curl -O https://raw.githubusercontent.com/afni/afni/master/src/other_builds/OS_notes.linux_ubuntu_24_64_a_admin.txt
bash OS_notes.linux_ubuntu_24_64_a_admin.txt

######################################
## Get some afni.   This will change to the user script
curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries
tcsh @update.afni.binaries -no_recur -package linux_ubuntu_24_ARM -bindir /usr/local/abin

## do the shell login path updates
/usr/local/abin/init_user_dotfiles.py -shell_list bash zsh tcsh csh \
-do_updates path apsearch -dir_bin /usr/local/abin -dir_dot /home/afni_user

######################################
## try to get R to work

## give permissions and make folder
chmod -R 777 /usr/local/lib/R/
mkdir -p home/afni_user/R

## set some paths
echo 'export R_LIBS=/home/afni_user/R' >> /home/afni_user/.bashrc
echo 'setenv R_LIBS /home/afni_user/R' >> /home/afni_user/.cshrc
R_LIBS=/home/afni_user/R
set R_LIBS /home/afni_user/R

## let's try manual R package installation
Rscript -e "install.packages(c('afex', 'phia', 'snow', 'nlme', 'lmerTest', \
'gamm4', 'data.table', 'paran', 'psych', 'corrplot', 'metafor', 'brms'),\
repos='https://cloud.r-project.org')"


######################################
## make folders and links for mounting local host drives and local syncs
mkdir -p /home/external/
chown -R afni_user:afni_user /home/afni_user/
chown -R afni_user:afni_user /home/external/

ln -s /home/external/.afnirc /home/afni_user/.afnirc
/usr/local/abin/afni_system_check.py -check_all > /home/afni_user/afni_system_check.txt

######################################
## grave yard
## fix GLwDrawA.h
## cd /usr/include/GL
## mv GLwDrawA.h GLwDrawA.h.orig
## sed 's/GLAPI WidgetClass/extern GLAPI WidgetClass/' GLwDrawA.h.orig > GLwDrawA.h 
