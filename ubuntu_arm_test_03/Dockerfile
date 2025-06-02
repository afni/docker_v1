FROM ubuntu:24.04

# Initial dockerfile for AFNI container, adjusting one from Vinai
# Roopchansingh (FMRIF, NIMH, NIH, USA).

# Need to have this line _AFTER_ the 'FROM' call, otherwise
# the build won't work.  So need to set the correct version
# in 2 places, but at least they are right next to each
# other.

# this needs to be built on an arm machine to create an arm container

ENV  VERSION_UBUNTU=24.04
# ENV  APACK=linux_ubuntu_24_64
# ENV  RVNUM            4.3
# ENV  RPACK            linux_ubuntu_24_R-${RVNUM}_libs
# ENV  AWEBS            https://afni.nimh.nih.gov/pub/dist/tgz

## add user afni_user in the docker container and give it a home folder
RUN useradd -m -d /home/afni_user -s /bin/bash afni_user

# Install package dependencies (**keep in sync with main source code
# OS_notes**)
ENV   BUILD_SCRIPT=create_machine_ARM.sh
ADD   $BUILD_SCRIPT   /tmp
RUN   sh              /tmp/$BUILD_SCRIPT
RUN   rm -f           /tmp/$BUILD_SCRIPT

# # Install AFNI binaries (note where 'abin' is)
# RUN   curl -O         ${AWEBS}/${APACK}.tgz
# RUN   tar -xf         ${APACK}.tgz
# RUN   mv              ${APACK}  /usr/local/abin
# RUN   rm -f           ${APACK}.tgz
# ENV   PATH=/usr/local/abin:$PATH

# # Install R packages (R-cran already installed, above), and
# # prepacked packages must match that version's MAJ.MIN nums.
# ENV   R_LIBS=/usr/local/share/R-${RVNUM}
# RUN   curl -O         ${AWEBS}/package_libs/${RPACK}.tgz
# RUN   tar -xf         ${RPACK}.tgz
# RUN   mv              ${RPACK}  ${R_LIBS}
# RUN   rm -f           ${RPACK}.tgz


# Default start-up command is just a plain ol' shell for now
ENTRYPOINT ["/bin/tcsh"]
