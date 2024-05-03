
Notes on installing the Docker engine on Ubuntu are here:
https://docs.docker.com/engine/install/ubuntu/
Specifically, PT is going to follow this route for installing:
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

This example setup has been modeling on Vinai Roopchansingh's from here:
https://github.com/roopchansinghv/dockerImage4DevMR

To build the image, check out options/notes from here:
https://docs.docker.com/get-started/02_our_app/
You can run (which took: 786.7s):

  docker build -t afni_doc_v1 .

where:
+ the '.' means to find a file called Dockerfile in the current
  directory
+ '-t ..' makes a tag for the created image, which will be effectively
  the name for referencing/using the created image. This can have more
  functionality, see https://docs.docker.com/reference/cli/docker/image/tag/

---------------------------------------------------------------------------

NOTES

When trying some docker commands, I kept getting this error message:
  permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.45/containers/json": dial unix /var/run/docker.sock: connect: permission denied

From here (https://stackoverflow.com/questions/47854463/docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socke), I then ran:
  
  sudo usermod -a -G docker $USER

... and then logged out and back in, and I was able to run docker
commands without an error, such as:

  docker container ls -a 
