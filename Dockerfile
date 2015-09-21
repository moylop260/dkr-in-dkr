# Build image $: docker build -t dkr-in-dkr
# Create container $: docker run --privileged -P --name my-dkr-in-dkr dkr-in-dkr
#             If add certificates use: -v docker_server:/docker_server -e DOCKER_DAEMON_ARGS="--tlsverify --tlscacert=/docker_server/ca.pem --tlscert=/docker_server/cert.pem --tlskey=/docker_server/key.pem"
# Add to your profile bash file $: alias mydkr="DOCKER_TLS_VERIFY=  DOCKER_CERT_PATH= DOCKER_HOST=tcp://REMOTE_IP:REMOTE_PORT docker"

FROM ubuntu:15.04

ADD ./files/docker_keys /docker_keys
ADD ./files/entrypoint.sh /entrypoint.sh

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    apparmor-profiles \
    iptables

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

# ENV to connect to docker locally into docker
ENV PORT 2376
ENV DOCKER_TLS_VERIFY 1
ENV DOCKER_CERT_PATH /docker_keys
ENV DOCKER_HOST=tcp://127.0.0.1:${PORT}

# Define additional metadata for our image.
VOLUME /var/lib/docker
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE ${PORT}

