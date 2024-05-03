FROM ubuntu:24.04

# Initial dockerfile for AFNI container, adjusting one from Vinai
# Roopchansingh (FMRIF, NIMH, NIH, USA).

# Need to have this line _AFTER_ the 'FROM' call, otherwise
# the build won't work.  So need to set the correct version
# in 2 places, but at least they are right next to each
# other.
ENV  VERSION_UBUNTU   24.04



# Subsume all package installation and system customization
# into a single shell script which can be repurposed for a
# direct / live machine installation.
ENV   MACHINE_BUILD_SCRIPT    create_machine.sh
ADD   $MACHINE_BUILD_SCRIPT   /tmp
RUN   sh                      /tmp/$MACHINE_BUILD_SCRIPT
RUN   rm -f                   /tmp/$MACHINE_BUILD_SCRIPT



# Default start-up command is just a plain ol' shell for now
ENTRYPOINT ["/bin/tcsh"]