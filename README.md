Docker in docker
================

 1. Create your keys and put in ./files/docker_keys more info [here](https://docs.docker.com/articles/https/)
 2. Build image:
    `docker build -t dkr-in-dkr .`
 3. Create container:
    `docker run --privileged -P --name=my-dkr-in-dkr dkr-in-dkr`
 4. Connect to your docker in docker:
    `"DOCKER_TLS_VERIFY=1  DOCKER_CERT_PATH={YOUR_LOCAL_CERT_PATH} DOCKER_HOST=tcp://{REMOTE_IP}:{REMOTE_PORT} docker {COMMAND}"`
    You can create a alias in your bash profile to run docker remote command easiest.

 Note: From step 2 to 4 you can execute `NAME="your_name" PORT="YOUR_PORT" ./run.sh`

Installation
============

 - Install docker last version (>=8.0)
