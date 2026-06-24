#!/bin/bash

#################################################
## 06/2026 Justin Rajendra
## launch the afni docker container on linux
## universal build

## get the current program name
prog="linux_afni_docker"

#################################################
## get arguments or show help

## default docker image
dock_img="discoraj/afni_docker_universal:latest"
pull="missing"
disp="${DISPLAY}"

argv=("")
for arg in "$@"; do
    argv+=("$arg")
done

narg=1
amax=$#

# Define the help function to replace the tcsh goto label
show_help() {
cat << EOF

   ----------------------------------------------------------------------------
   $prog ~1~

           Helper script to launch the afni docker on most Linux variants.
           This script does not need any arguments.  

           REQUIREMENTS:  
           1. This MUST be run on Linux.
           2. Docker MUST be installed and running.

           This script will check for all of the above.
   -----------------------------------------------------------------------------
   options: ~1~

      -latest      : Pull a new afni docker image even if an older one exists.
                     This will overwrite the previous local image with the 
                     newest one from docker hub.
                     If the afni docker image 
                     does not exist locally, the latest will be pulled.
      -image [IMG] : Launch a different docker image.  This can be a local 
                     image or something from docker hub.
                     Default is 'discoraj/afni_docker_universal:latest'.

      -help        : Show this help.
   -----------------------------------------------------------------------------
   examples: ~1~

      $prog
                : Just launch the afni docker.
      $prog -latest
                : Launch the afni docker and update the local image.
      $prog -image "Public_Image_Ltd"
                : Launch the docker with the image named "Public_Image_Ltd".
                  This will look for the image locally or pull it from docker 
                  hub.
      $prog -help

   -----------------------------------------------------------------------------
   Justin Rajendra 06/2026

EOF
exit 0
}

# Reverted to index-based while loop
while [ $narg -le $amax ]; do
    if [ "${argv[$narg]}" = "-image" ]; then
        ((narg++))
        dock_img="${argv[$narg]}"
    elif [ "${argv[$narg]}" = "-display" ]; then
        ((narg++))
        disp="${argv[$narg]}"
    elif [ "${argv[$narg]}" = "-latest" ]; then
        pull="always"
    elif [ "${argv[$narg]}" = "-help" ] || [ "${argv[$narg]}" = "-h" ]; then
        show_help
    else
        show_help
    fi
    ((narg++))
done

################################################
## check to see if things exist / are installed

## check for Linux
OpSys="`uname -s`"
if [ "$OpSys" != "Linux" ]; then
    echo
    echo "** ERROR: You don't seem to be running Linux."
    echo
    echo "If you are, there may be a problem with this program..."
    echo "Please post the error to: https://discuss.afni.nimh.nih.gov"
    echo
    exit 1
fi

## check for docker
docker_bin="`command -v docker`"
if [ "$docker_bin" == "" ]; then
    echo
    echo "** ERROR: Docker not found."
    echo
    echo "Is Docker installed?"
    echo "Installation instructions can be found at: "
    echo "https://docs.docker.com/get-docker/"
    echo
    exit 1
fi

######################################################
## Check for docker group and if the user is a member.
docker_grp_exists="`getent group | grep docker`"
if [ "$docker_grp_exists" = "" ]; then
    echo
    echo "** ERROR: The docker group does not exist."
    echo
    echo "Please create the docker group (sudo groupadd docker) "
    echo "and add yourself to it (sudo usermod -aG docker $USER)."
    echo "Then restart your computer."
    echo "If you are in the docker group, there may be a problem with this program..."
    echo "Please post the error to: https://discuss.afni.nimh.nih.gov"
    echo
    exit 1
fi

docker_member="`groups $USER | grep docker`"
if [ "$docker_member" = "" ]; then
    echo
    echo "** ERROR: You don't seem to be in the docker group."
    echo
    echo "This may cause issues with permissions when running the docker container."
    echo "If you haven't already, you may want to add yourself to the docker "
    echo "group (sudo usermod -aG docker $USER) and restart your computer."
    echo "If you are in the docker group, there may be a problem with this program..."
    echo "Please post the error to: https://discuss.afni.nimh.nih.gov"
    echo
    exit 1
fi

#########################################################
## check to see if things are running.
docker_active="`systemctl is-active docker`"
if [ "$docker_active" = "inactive" ]; then
    echo
    echo "** ERROR: Docker is not running."
    echo
    echo "Please start the docker service (sudo systemctl start docker) "
    echo "and try again."
    echo "Please post the error to: https://discuss.afni.nimh.nih.gov"
    echo
    exit 1
fi

###########################################################################
## run docker container

## run the docker
echo ; echo "Launching ${dock_img} ...beep boop beep boop..." ; echo

docker run -ti --rm \
           -u root \
           -v "${HOME}":/home/external \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           --env DISPLAY="${disp}" \
           --env USERID="`id -u`" \
           --env GRPID="`id -g`" \
           --env GRPNAME="`id -gn`" \
           --env USERNAME="`id -u -n`" \
           --pull "${pull}" \
           "${dock_img}"
exit 0
