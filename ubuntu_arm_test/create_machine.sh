#!/bin/sh

# This file is a duplicate of this one in the afni GitHub repo:
#   src/other_builds/OS_notes.linux_ubuntu_24_64_a_admin.txt
# NB: the 'sudo ..' part of each has been removed

# add universe repo
add-apt-repository universe -y

# update package manager
apt-get update

# get main dependencies
apt-get install -y      tcsh xfonts-base libssl-dev       \
                        python-is-python3                 \
                        python3-matplotlib python3-numpy  \
                        python3-flask python3-flask-cors  \
                        python3-pil                       \
                        gsl-bin netpbm gnome-tweaks       \
                        libjpeg62 xvfb xterm vim curl     \
                        gedit evince eog                  \
                        libglu1-mesa-dev libglw1-mesa-dev \
                        libxm4 build-essential            \
                        libcurl4-openssl-dev libxml2-dev  \
                        libgfortran-14-dev libgomp1       \
                        gnome-terminal nautilus           \
                        firefox xfonts-100dpi             \
                        r-base-dev cmake bc               \
                        libxext-dev libxmu-dev libxpm-dev \
                        libgsl-dev libglut-dev libxi-dev  \
                        libglib2.0-dev git

# get more dependencies for R-package brms
apt-get install -y      libgdal-dev libopenblas-dev       \
                        libnode-dev libudunits2-dev

# fix GLwDrawA.h
cd /usr/include/GL
mv GLwDrawA.h GLwDrawA.h.orig
sed 's/GLAPI WidgetClass/extern GLAPI WidgetClass/' GLwDrawA.h.orig > GLwDrawA.h 

## testing portion for building ##########
## paths and permissions need work

## fully mess up paths
mkdir -p /usr/local/abin
chmod -R 755 /usr/local/abin
cd /usr/local

## get some afni
curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries
tcsh @update.afni.binaries -no_recur -package anyos_text_atlas -bindir /usr/local/abin
/usr/local/abin/init_user_dotfiles.py -shell_list bash zsh tcsh -do_updates path apsearch -dir_bin /usr/local/abin

## this fails for some reason
# source ~/.cshrc

## build it
/usr/local/abin/build_afni.py -build_root /usr/local/afni_build -package linux_universal

## the build doesn't seem to copy it over
cp -rf /usr/local/afni_build/build_src/linux_universal/* /usr/local/abin/