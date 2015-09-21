
FROM ubuntu:15.04

ADD ./files/docker_keys /docker_keys

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    vim

# Force install docker >= 1.8
RUN echo deb https://apt.dockerproject.org/repo \
   ubuntu-`cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d'=' -f2` main \
   >> /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F76221572C52609D && \
    apt-get update && \
    apt-get install -y docker-engine

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

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["/entrypoint.sh"]
EXPOSE ${PORT}

