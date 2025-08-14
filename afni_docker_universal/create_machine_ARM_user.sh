#!/bin/bash

###############################################
## user level install for afni docker on arm
## suma does not yet work...

## echo commands to terminal
set -x

######################################
## Get some afni.
cd 
curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries
tcsh @update.afni.binaries -no_recur -package linux_ubuntu_24_ARM \
     -bindir /usr/local/abin -do_dotfiles -apsearch no

## add to path
export PATH=$PATH:/usr/local/abin

######################################
## get the help auto complete
curl -O https://afni.nimh.nih.gov/pub/dist/tgz/package_libs/afni_all_progs_COMP.tgz
tar -xvzf afni_all_progs_COMP.tgz
rm -f afni_all_progs_COMP.tgz

## do the shell login path updates  (does this add the all_progs.COMP?)
init_user_dotfiles.py -shell_list bash zsh tcsh -do_updates apsearch path \
                      -dir_bin /usr/local/abin -dir_dot /home/afni_user

## add the auto complete manually...(bash works but csh/tcsh does not work)
cat <<EOT >> /home/afni_user/.cshrc
# set up tab completion for AFNI programs
# (only do this in an interactive shell)
if ( \$?prompt ) then
   if ( "\$prompt" != "" ) then
      if ( -f \$HOME/.afni/help/all_progs.COMP ) then
         source \$HOME/.afni/help/all_progs.COMP
      endif
   endif
endif
EOT

######################################
## get pre compiled R packages

## set some paths and define a variable for the R library location
echo 'export R_LIBS=/home/afni_user/R' >> /home/afni_user/.bashrc
echo 'setenv R_LIBS /home/afni_user/R' >> /home/afni_user/.cshrc

## export so child processes inherit it
export R_LIBS=/home/afni_user/R

## get the pre-compiled R libraries
curl -O https://afni.nimh.nih.gov/pub/dist/tgz/package_libs/linux_ubuntu_24_ARM_R-4.3_libs.tgz
tar -xvzf linux_ubuntu_24_ARM_R-4.3_libs.tgz
mv linux_ubuntu_24_ARM_R-4.3_libs /home/afni_user/R
rm -f linux_ubuntu_24_ARM_R-4.3_libs.tgz

######################################
## this will show warnings for dot files and boot camp data
afni_system_check.py -check_all > /home/afni_user/afni_system_check.txt

