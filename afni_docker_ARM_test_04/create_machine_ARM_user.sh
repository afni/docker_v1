#!/bin/bash

###############################################
## user level install for afni docker on arm


######################################
## Get some afni.
cd 
curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries
tcsh @update.afni.binaries -no_recur -package linux_ubuntu_24_ARM \
     -bindir ~/abin -do_dotfiles -apsearch no

## add to path
PATH=$PATH:~/abin

## do the shell login path updates
init_user_dotfiles.py -shell_list bash zsh tcsh csh -do_updates path \
                      -dir_bin ~/abin -dir_dot /home/afni_user

######################################
## get the help auto complete
cd /home/afni_user
curl -O https://afni.nimh.nih.gov/pub/dist/tgz/package_libs/afni_all_progs_COMP.tgz
tar -xvzf afni_all_progs_COMP.tgz
rm -f afni_all_progs_COMP.tgz

## I don't think this is doing anything
source /home/afni_user/.afni/help/all_progs.COMP.bash

######################################
## try to get R to work

## set some paths and define a variable for the R library location
echo 'export R_LIBS=/home/afni_user/R' >> /home/afni_user/.bashrc
echo 'setenv R_LIBS /home/afni_user/R' >> /home/afni_user/.cshrc
R_LIBS=/home/afni_user/R

## get the pre-compiled R libraries
cd /home/afni_user
curl -O https://afni.nimh.nih.gov/pub/dist/tgz/package_libs/linux_ubuntu_24_ARM_R-4.3_libs.tgz
tar -xvzf linux_ubuntu_24_ARM_R-4.3_libs.tgz
mv linux_ubuntu_24_ARM_R-4.3_libs /home/afni_user/R
rm -f linux_ubuntu_24_ARM_R-4.3_libs.tgz

afni_system_check.py -check_all > /home/afni_user/afni_system_check.txt
