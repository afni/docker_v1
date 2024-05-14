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
                        r-base-dev cmake bc

# get more dependencies for R-package brms
apt-get install -y      libgdal-dev libopenblas-dev       \
                        libnode-dev libudunits2-dev

