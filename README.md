AFNI Docker V1 (`docker_v1`)

This repository serves as a streamlined, direct approach to building or launching containerized versions of **AFNI (Analysis of Functional NeuroImages)**. It aims to reduce dependency conflicts and installation overhead, making it easier to deploy AFNI in a Docker on different operating systems (various Linux distributions and macOS) and on different CPU architectures (Intel/x86, Apple Silicon, ARM).  Windows is not yet supported.

## Repository Structure

* **`afni_docker_universal/`**: Contains the foundational `Dockerfile` configuration and setup scripts needed to assemble a universal AFNI container environment.
* **`mac_docker_launch.sh`**: A dedicated shell script wrapper engineered to automate volume mounting, user permission management, and GUI/X11 rendering parameters specifically for macOS users.
* **`linux_docker_launch.sh`**: Same as above but for linux.

---

## Prerequisites

Before running the container or utilizing the utility scripts, ensure your host computer satisfies these system requirements:

1.  **Docker**: Ensure Docker Desktop and/or Docker Engine is installed and actively running.
2.  **X11 Display Server** *(Required for interactive GUI elements like the AFNI/SUMA viewer)*:
    * **macOS**: Download and install [XQuartz](https://www.xquartz.org/).
    * **Linux**: Standard X11 utilities are usually pre-packaged.

---

## Getting Started

### 1. Building the Container Locally
If you want to construct the image directly using the localized source files under the universal directory, execute:
```bash
cd afni_docker_universal
docker build -t afni_universal .
```

---

This was writen with Ai.