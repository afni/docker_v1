#!/bin/bash

#################################################
## 07/2026 Justin Rajendra
## launch the afni docker container on macOS or Linux
## universal build

## get the current program name
prog="launch_afni_docker"

## default docker image
dock_img="discoraj/afni_docker_universal:latest"
pull="missing"
disp=""

#################################################
## help!
show_help() {
cat << EOF

   ----------------------------------------------------------------------------
   $prog ~1~

           Helper script to launch the afni docker on macOS and most Linux 
           variants. This script does not need any arguments.  

           REQUIREMENTS: ~2~
           1. This MUST be run on macOS or and most Linux variants.
              (Windows is not yet supported)
           2. Docker MUST be installed and running.
           3. On macOS, Xquartz MUST be installed and running.

           The script will check for all of the above.

           NOTES: ~2~
           1. The afni docker will be launched with the current user's home 
              directory mounted to /home/external in the docker container. 
              This allows you to access your files from within the docker 
              container. The Docker program may give you a warning about this,  
              but it is safe to ignore.
           2. The docker container will be launched with the current user's 
              UID and GID. This allows you to create and access files in your 
              home directory from within the docker container without 
              permission issues.
           3. On some Linux variants, the Docker Desktop may block X11 
              forwarding. If this happens, you can try the -display option 
              to set a different display environment variable. However, this 
              may not work and the using Docker engine instead of the the 
              Docker Desktop may be the only way to fix this issue. Please 
              see the Docker documentation for more information.

   -----------------------------------------------------------------------------
   options: ~1~

      -latest         : Pull a new afni docker image even if an older one 
                        exists. This will overwrite the previous local image 
                        with the newest one from docker hub. If the afni docker 
                        image does not exist locally, the latest will be pulled.
      -image [IMG]    : Launch a different docker image.  This can be a local 
                        image or something from docker hub.
                        Default is 'discoraj/afni_docker_universal:latest'.
      -display [DISP] : Use a different display environment variable for 
                        testing purposes.
                        Please surround text in double quotes " ".
                        Defaults (as of 07/2026) are:
                        macOS: "host.docker.internal:0"
                        Linux: DISPLAY environment variable.
      -help           : Show this help.

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

   -----------------------------------------------------------------------------
   Justin Rajendra 07/2026

EOF
exit 0
}

#################################################
## get arguments or show help

argv=("")
for arg in "$@"; do
    argv+=("$arg")
done

narg=1 ; amax=$#
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

#################################################
## detect os type and set display variable

if [[ "$OSTYPE" == "darwin"* ]]; then
    # echo "Running on macOS"
    os="macos"
    ## set default display variable if not set
    if [[ -z "$disp" ]]; then
        disp="host.docker.internal:0"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # echo "Running on Linux"
    os="linux"
    ## set default display variable if not set
    if [[ -z "$disp" ]]; then
        disp="${DISPLAY}"
    fi
else
    echo ; echo "** ERROR: You don't seem to be running on a supported OS." ; echo
    echo "If you are, there may be a problem with this program..."
    echo "Please post the error to: https://discuss.afni.nimh.nih.gov" ; echo
    exit 1
fi

#################################################
## check to see if things exist / are installed

## check for docker
docker_bin=`command -v docker`
if [[ -z "$docker_bin" ]]; then
    echo
    echo "** ERROR: Docker not found."
    echo
    echo "Is Docker installed?"
    echo "Installation instructions can be found at: "
    echo "https://docs.docker.com/engine/"
    echo
    exit 1
fi

#################################################
## checks for macOS
if [[ "$os" == "macos" ]]; then

    #################################################
    ## check for installed XQuartz
    xquartz_bin=`command -v Xquartz || command -v XQuartz`
    if [[ -z "$xquartz_bin" ]]; then
        ## Fallback in case it is installed but not in PATH
        if [[ ! -d "/Applications/Utilities/XQuartz.app" && ! -d "/Applications/XQuartz.app" ]]; then
            echo ; echo "** ERROR: XQuartz not found." ; echo
            echo "Is XQuartz installed and in your PATH?"
            echo "If not, you can install it from homebrew"
            echo "or from here: https://www.xquartz.org" ; echo
            exit 1
        fi
    fi   ## end of installed XQuartz check

    #################################################
    ## check for Xquartz security setting
    xquartz_sec=`defaults read org.xquartz.X11.plist nolisten_tcp`
    xquartz_auth=`defaults read org.xquartz.X11 no_auth`

    if [[ "$xquartz_sec" == "1" || "$xquartz_auth" == "0" ]]; then
        echo ; echo "** ERROR: XQuartz is blocking tcp clients needed for docker."
        echo
        echo "You can fix this by entering the following commands with XQuartz quit:"
        echo "defaults write org.xquartz.X11.plist nolisten_tcp -bool false"
        echo "defaults write org.xquartz.X11 no_auth -boolean true"
        echo
        echo "OR you can do this in the Security tab of the Settings in XQuartz."
        echo "Uncheck the 'Authenticate connections' box."
        echo "AND"
        echo "Check the 'Allow connections from network clients' box."
        echo
        echo "OR I can fix this for you now."
        echo "Do you want me to fix this? You only have to do this once."
        echo "XQuartz will need to be quit to do this."
        echo
        
        read -p "Enter Y to quit XQuartz and fix this or enter anything else to exit: " fix

        if [[ "$fix" == "Y" ]]; then
            xquart_pid=`pgrep -i Xquartz`
            if [[ -n "$xquart_pid" ]]; then
                echo "Killing all XQuartz..."
                killall Xquartz
                sleep 2
            fi
            echo
            echo "defaults write org.xquartz.X11.plist nolisten_tcp -bool false"
            defaults write org.xquartz.X11.plist nolisten_tcp -bool false
            echo "defaults write org.xquartz.X11 no_auth -boolean true"
            defaults write org.xquartz.X11 no_auth -bool true
            echo
        else
            echo
            echo "Please fix the XQuartz setting with the above instructions."
            echo
            exit 1
        fi
    fi   ## end check for XQuartz security setting

    #################################################
    ## check if docker is running and launch it if not

    ## this file should exist if docker is running
    if [[ ! -e "/Users/${USER}/.docker/run/docker.sock" ]]; then
        echo ; echo "+* Warning: Docker daemon is not running."
        echo "Launching Docker daemon. Please wait."
        open -a Docker
        sleep 5 ; echo

        while [[ ! -e "/Users/${USER}/.docker/run/docker.sock" ]]; do 
            echo "Waiting for Docker daemon..."
            sleep 2
        done
    fi   ## end launch docker if not running

    #################################################
    ## check if XQuartz is running and launch it if not
    xquart_pid=`pgrep -i Xquartz`
    if [[ -z "$xquart_pid" ]]; then
        echo ; echo "+* Warning: Xquartz is not running."
        echo "Launching Xquartz. Please wait."
        open -a XQuartz
        sleep 5 ; echo

        while true; do 
            xquart_pid=`pgrep -i Xquartz`
            if [[ -z "$xquart_pid" ]]; then
                echo "Waiting for Xquartz..."
                sleep 2
            else
                break
            fi
        done
    fi   ## end launch XQuartz if not running

fi   ## end of macOS check

#################################################
## checks for linux
if [[ "$os" == "linux" ]]; then

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
    fi   ## end of docker group check

    #########################################################
    ## check to see if docker is running.
    docker_active="`systemctl is-active docker`"
    docker_desktop_active="`systemctl --user is-active docker-desktop`"
    if [ "$docker_active" = "active" ] || [ "$docker_desktop_active" = "active" ]; then
        echo
        echo "Docker is running."
        echo
    else 
        echo
        echo "** ERROR: Docker is not running."
        echo
        echo "Please start the docker service:"
        echo "sudo systemctl start docker"
        echo "or"
        echo "systemctl --user start docker-desktop"
        echo "Then try again."
        echo "Please post the error to: https://discuss.afni.nimh.nih.gov"
        echo
        exit 1
    fi   ## end of docker running check

fi   ## end of linux check

###########################################################################
## run docker container

echo ; echo "Launching ${dock_img} ...beep boop beep boop..." ; echo
# xhost +SI:localuser:$USER
docker run -ti --rm \
       -u root \
       -v "${HOME}:/home/external" \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       --env DISPLAY="${disp}" \
       --env USERID="`id -u`" \
       --env GRPID="`id -g`" \
       --env GRPNAME="`id -gn`" \
       --env USERNAME="`id -u -n`" \
       --pull "${pull}" \
       "${dock_img}"
exit 0