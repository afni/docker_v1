FROM ubuntu:24.04

## 07/2025 Justin Rajendra
## This Dockerfile is meant to build a docker image with afni pre installed
## and configured for use on arm and x86 platforms
## should be run with "--platform=linux/amd64,linux/arm64" during build

## get the target platforms for the different build
ARG TARGETPLATFORM
RUN echo "$TARGETPLATFORM"

## copy root scripts for dependencies
ENV ROOT_SCRIPT_ARM=create_machine_ARM_root.sh
ENV ROOT_SCRIPT_x86=create_machine_x86_root.sh
ADD $ROOT_SCRIPT_ARM /tmp
ADD $ROOT_SCRIPT_x86 /tmp

## run scripts based on platform (windows is just a placeholder for now)
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        bash /tmp/$ROOT_SCRIPT_ARM; \
    elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        bash /tmp/$ROOT_SCRIPT_x86; \
    elif [ "$TARGETPLATFORM" = "windows/amd64" ]; then \
        bash /tmp/$ROOT_SCRIPT_x86; \
    fi

## clean up
RUN rm -f /tmp/$ROOT_SCRIPT_ARM
RUN rm -f /tmp/$ROOT_SCRIPT_x86

## add user afni_user in the docker container and give it a home folder
RUN useradd -m -d /home/afni_user -s /bin/bash afni_user

## copy user scripts for afni install
ENV USER_SCRIPT_ARM=create_machine_ARM_user.sh
ENV USER_SCRIPT_x86=create_machine_x86_user.sh
ADD $USER_SCRIPT_ARM /home/afni_user
ADD $USER_SCRIPT_x86 /home/afni_user

## change to the afni user for the next scripts
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
RUN rm -f /tmp/$USER_SCRIPT_ARM
RUN rm -f /tmp/$USER_SCRIPT_x86

## Default start-up command is just a plain ol' shell for now
ENTRYPOINT ["/bin/bash"]
