
FROM ubuntu:14.04
# FROM ubuntu:14.04

ADD ./files/docker_keys /docker_keys

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    apparmor-profiles \
    lxc \
    vim \
  && rm -rf /var/lib/apt/lists

# Fix warning modprobe:
# http://askubuntu.com/questions/459296/could-not-open-moddep-file-lib-modules-3-xx-generic-modules-dep-bin-when-mo
# RUN apt-get install --reinstall linux-image-3.13.0
# RUN apt-get install --reinstall linux-image-3.19.0

# install docker lastest
RUN curl -sSL https://get.docker.com/ | sh \
  && rm -rf /var/lib/apt/lists \
  && rm -rf /var/lib/docker
# RUN curl -sSL https://get.docker.com/ | sh
# ENV to connect to docker locally into docker
ENV PORT 2376
ENV DOCKER_TLS_VERIFY 1
ENV DOCKER_CERT_PATH /docker_keys
ENV DOCKER_HOST=tcp://127.0.0.1:${PORT}

# Creating entrypoint script
RUN echo "#!/bin/bash \
    \n/usr/bin/docker daemon --tlsverify --tlscacert=/docker_keys/ca.pem \
    --tlscert=/docker_keys/server-cert.pem --tlskey=/docker_keys/server-key.pem \
    -H=0.0.0.0:${PORT}" | tee -a /entrypoint.sh \
    && chmod +x /entrypoint.sh

# ENV to connect to docker locally into docker
ENV PORT=2376 DOCKER_TLS_VERIFY=1 DOCKER_CERT_PATH=/docker_keys DOCKER_HOST=tcp://127.0.0.1:${PORT}

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["/entrypoint.sh"]
EXPOSE ${PORT}

