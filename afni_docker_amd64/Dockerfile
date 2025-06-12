FROM --platform=amd64 ubuntu:24.04

## I know that the --platform will give a warning,
## but I want to force the amd64 because the afni binaries are x86

## add user afni_user in the docker container and give it a home folder
RUN useradd -m -d /home/afni_user -s /bin/bash afni_user

## root script for dependencies
ENV ROOT_SCRIPT=create_machine_amd64_root.sh
ADD $ROOT_SCRIPT /tmp
RUN bash /tmp/$ROOT_SCRIPT
RUN rm -f /tmp/$ROOT_SCRIPT

## user script for afni install
ENV USER_SCRIPT=create_machine_amd64_user.sh
ADD $USER_SCRIPT /home/afni_user
USER afni_user
RUN bash /home/afni_user/$USER_SCRIPT
RUN rm -f /home/afni_user/$USER_SCRIPT

## Default start-up command is just a plain ol' shell for now
ENTRYPOINT ["/bin/bash"]
