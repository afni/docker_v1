FROM ubuntu:24.04

## 08/2025 Justin Rajendra
## This Dockerfile is meant to build a docker image with afni pre installed
## and configured for use on arm and x86 platforms
## can be run with "--platform=linux/amd64,linux/arm64" during build

## get the target platforms for the different builds
ARG TARGETPLATFORM

## add user afni_user in the docker container and give it a home folder
RUN useradd -m -d /home/afni_user -s /bin/bash afni_user

## copy root scripts for dependencies
ENV ROOT_SCRIPT=create_machine_root.sh
ADD $ROOT_SCRIPT /tmp

## run root script (same script for arm and x86)
RUN bash /tmp/$ROOT_SCRIPT

## clean up
RUN rm -f /tmp/$ROOT_SCRIPT

## copy user scripts for afni install
ENV USER_SCRIPT_ARM=create_machine_ARM_user.sh
ENV USER_SCRIPT_x86=create_machine_x86_user.sh
ADD $USER_SCRIPT_ARM /home/afni_user
ADD $USER_SCRIPT_x86 /home/afni_user

## change to the afni user for the next steps
USER afni_user

## run scripts based on platform (windows is just a placeholder for now)
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        bash /home/afni_user/$USER_SCRIPT_ARM; \
    elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        bash /home/afni_user/$USER_SCRIPT_x86; \
    elif [ "$TARGETPLATFORM" = "windows/amd64" ]; then \
        bash /home/afni_user/$USER_SCRIPT_x86; \
    fi

## clean up
RUN rm -f /home/afni_user/$USER_SCRIPT_ARM
RUN rm -f /home/afni_user/$USER_SCRIPT_x86

## Default start-up command is just a plain ol' shell for now
ENTRYPOINT ["/bin/bash"]
