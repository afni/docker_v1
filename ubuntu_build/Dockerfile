FROM ubuntu:24.04

# Initial dockerfile for AFNI container, adjusting one from Vinai
# Roopchansingh (FMRIF, NIMH, NIH, USA).

# Rather than have consecutive RUN statements, serialize single RUN
# calls with semicolon(s) to reduce number of layers and save space
# (particularly when an rm is involved). The chunking of steps here
# seems to be reasonable for conceptual organization (i.e., it is
# still OK to have some layers).

# Need to have this line _AFTER_ the 'FROM' call, otherwise
# the build won't work.  So need to set the correct version
# in 2 places, but at least they are right next to each
# other.
ENV  VERSION_UBUNTU   24.04
ENV  APACK            linux_ubuntu_24_64
ENV  RVNUM            4.3
ENV  RPACK            linux_ubuntu_24_R-${RVNUM}_libs
ENV  AWEBS            https://afni.nimh.nih.gov/pub/dist/tgz

# Install package dependencies (**keep in sync with main source code
# OS_notes**)
ENV   BUILD_SCRIPT    create_machine.sh
ADD   $BUILD_SCRIPT   /tmp
RUN   sh              /tmp/$BUILD_SCRIPT ; \
      rm -f           /tmp/$BUILD_SCRIPT

# Install AFNI binaries (note where 'abin' is)
RUN   curl -O         ${AWEBS}/${APACK}.tgz ; \
      tar -xf         ${APACK}.tgz ; \
      mv              ${APACK}  /usr/local/abin ; \
      rm -f           ${APACK}.tgz
ENV   PATH=/usr/local/abin:$PATH

# Install R packages (R-cran already installed, above), and
# prepacked packages must match that version's MAJ.MIN nums.
ENV   R_LIBS=/usr/local/share/R-${RVNUM}
RUN   curl -O         ${AWEBS}/package_libs/${RPACK}.tgz ; \
      tar -xf         ${RPACK}.tgz ; \
      mv              ${RPACK}  ${R_LIBS} ; \
      rm -f           ${RPACK}.tgz


# Default start-up command is just a plain ol' shell for now
ENTRYPOINT ["/bin/tcsh"]
