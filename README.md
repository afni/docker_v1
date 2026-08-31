# AFNI Docker V1 (`docker_v1`)

This repository serves as a streamlined, direct approach to building or launching containerized versions of **AFNI (Analysis of Functional NeuroImages)**. It aims to reduce dependency conflicts and installation overhead, making it easier to deploy AFNI in a Docker on different operating systems (various Linux distributions and macOS) and on different CPU architectures (Intel/x86, Apple Silicon, ARM).  Windows is not yet supported.

## Repository Structure

* **`afni_docker_universal/`**: Contains the foundational `Dockerfile` configuration and setup scripts needed to assemble a universal AFNI container environment.
* **`launch_afni_docker.sh`**: A dedicated shell script wrapper engineered to automate volume mounting, user permission management, and GUI/X11 rendering parameters.

---

# Prerequisites

Before running the container or utilizing the launcher script, ensure your host computer satisfies these system requirements:

1.  **Docker**: Ensure Docker Desktop and/or Docker Engine is installed and actively running.
    * Docker Desktop on some Linux variants may block connections necessary for X11 windows.    Use the Docker Engine if possible. (See Linux Notes below for more information)
2.  **X11 Display Server** *(Required for interactive GUI elements like the AFNI/SUMA viewer)*:
    * **macOS**: Download and install [XQuartz](https://www.xquartz.org/).
    * **Linux**: Standard X11 utilities are usually pre-packaged.

---

# Using the Launching Script

1.  Executing `launch_afni_docker.sh` with no arguments will configure and launch the afni 
    docker. 
    * See `launch_afni_docker.sh -help` for more info.
2. The afni docker will be launched with the current user's home 
   directory mounted to /home/external in the docker container. 
   This allows you to access your files from within the docker 
   container. The Docker program may give you a warning about this, 
   but it is safe to ignore.
3. The docker container will be launched with the current user's 
   UID and GID. This allows you to create and access files in your 
   home directory from within the docker container without 
   permission issues.
4. To exit the docker container, type 'exit' or 'Ctrl+d' **TWICE** in 
   the terminal.  Once to get out user shell and once to exit the 
   docker container.  If you only type 'exit' or 'Ctrl+d' **ONCE**, 
   you will be returned to the root shell in the docker container.

---

# macOS Notes

There are some settings on XQuartz that may prevent the AFNI/SUMA GUI from displaying. The `launch_afni_docker.sh` script will attempt to set the correct settings. There will be prompt to allow the script to set these settings. You can choose to allow or deny this. The warning messages will include instructions on how to manually set these settings if you choose to deny the script permission to set them.

## tl;dr
**To summarize the notes below, the following commands will set the XQuartz security settings and enable indirect GLX rendering:**
```bash
   defaults write org.xquartz.X11.plist nolisten_tcp -bool false
   defaults write org.xquartz.X11 no_auth -boolean true
   defaults write org.xquartz.X11 enable_iglx -bool true
```
Then restart XQuartz and the terminal for the changes to take effect.

**To restore the default settings, run the following commands:**
```bash
   defaults write org.xquartz.X11.plist nolisten_tcp -bool true
   defaults write org.xquartz.X11 no_auth -boolean false
   defaults write org.xquartz.X11 enable_iglx -bool false
```
Then restart XQuartz and the terminal for the changes to take effect.

## XQuartz Security Settings
There are two security settings that need to be set correctly for the AFNI/SUMA GUI to display. 
1. The first setting is `Allow connections from network clients`.
2. The second setting is `Authenticate connections`. 

### To manually set the security settings from the XQuartz GUI, follow these steps:

1. Open XQuartz and go to `XQuartz` > `Preferences` > `Security`.
2. Ensure that the option `Allow connections from network clients` is **CHECKED**.
3. Ensure that the option `Authenticate connections` is **UNCHECKED**.
4. Restart XQuartz for the changes to take effect.

*(Reverse the above steps if you want to restore the default settings).*

### To manually set the security settings from the command line, follow these steps:

Open a terminal and run the following commands to allow all connections from unauthenticated network clients:
```bash        
   defaults write org.xquartz.X11.plist nolisten_tcp -bool true
   defaults write org.xquartz.X11 no_auth -boolean false
```
Then restart XQuartz and the terminal for the changes to take effect.

*To restore the default settings, run the following commands:*
```bash
   defaults write org.xquartz.X11.plist nolisten_tcp -bool false
   defaults write org.xquartz.X11 no_auth -boolean true
```
Then restart XQuartz and the terminal for the changes to take effect.

## Xquartz indirect GLX setting for SUMA
To enable indirect GLX rendering, run the following command in a terminal:
```bash
   defaults write org.xquartz.X11 enable_iglx -bool true
```
Then restart XQuartz and the terminal for the changes to take effect.

*To restore the default settings, run the following commands:*
```bash
   defaults write org.xquartz.X11 enable_iglx -bool false
```
Then restart XQuartz and the terminal for the changes to take effect.

---

# Linux Notes

- On Linux, the user needs to be in the `docker` group to run this script. 
   If you are not in the docker group, the script will exit with an error. 
   You need administrative privileges to create the docker group and add 
   yourself to the group. You can create the docker group with the following 
   command: `sudo groupadd docker`. You can add yourself to the docker 
   group with the following command: `sudo usermod -aG docker $USER`.
   You need to restart your computer or log out and log back in for 
   the group changes to take effect. Running the script with `sudo` 
   will not fix this issue. 
- On some Linux variants, the Docker Desktop may block X11 
   forwarding. If this happens, you can try the `-display` option 
   to set a different display environment variable. However, this 
   may not work and the using Docker engine instead of the the 
   Docker Desktop may be the only way to fix this issue. Please 
   see the Docker documentation for more information.

---

# Building and Running the Container Locally
If you want to construct the image directly using the localized source files under the afni_docker_universal directory, execute:
```bash
git clone https://github.com/afni/docker_v1.git
cd docker_v1/afni_docker_universal
docker build -t afni_universal .
```

### To run the container on macOS, use:
```bash
docker run -ti --rm \
       -u root \
       -v "${HOME}:/home/external" \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       --env DISPLAY="host.docker.internal:0" \
       --env USERID="`id -u`" \
       --env GRPID="`id -g`" \
       --env GRPNAME="`id -gn`" \
       --env USERNAME="`id -u -n`" \
       afni_universal
```

### To run the container on Linux, use:
```bash
docker run -ti --rm \
       -u root \
       -v "${HOME}:/home/external" \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       --env DISPLAY="${DISPLAY}" \
       --env USERID="`id -u`" \
       --env GRPID="`id -g`" \
       --env GRPNAME="`id -gn`" \
       --env USERNAME="`id -u -n`" \
       afni_universal
```

---
