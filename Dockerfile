## -*- docker-image-name: "tmaier/scaleway-gitlab-runner:latest" -*-
FROM scaleway/debian:amd64-stretch
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/debian:i386-stretch        # arch=i386
#FROM scaleway/debian:mips-stretch        # arch=mips

LABEL maintainer="Tobias Maier <me@tobiasmaier.info> @tobias_maier"

# Prepare rootfs for image-builder
RUN /usr/local/sbin/scw-builder-enter

# Update OS
RUN apt-get update \
 && apt-get --force-yes -y upgrade \
 && apt-get clean

# Install unattended updates
RUN apt-get install -y unattended-upgrades \
  && apt-get clean

## Install gitlab-runner
# Source: https://docs.gitlab.com/runner/install/linux-repository.html#installing-the-runner
COPY patches/pin-gitlab-runner.pref /etc/apt/preferences.d/pin-gitlab-runner.pref
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash \
  && apt-get install -y gitlab-runner \
  && apt-get clean

ARG DOCKER_MACHINE_VERSION=0.14.0

## Install docker-machine
# Source: https://docs.docker.com/machine/install-machine/#install-machine-directly
RUN curl -L "https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-$(uname -s)-$(uname -m)" >/usr/local/bin/docker-machine && \
  chmod +x /usr/local/bin/docker-machine

ARG DOCKER_MACHINE_SCALEWAY_VERSION=1.3

## Install docker-machine-driver-scaleway
# Source: https://github.com/scaleway/docker-machine-driver-scaleway
RUN curl -sL "https://github.com/scaleway/docker-machine-driver-scaleway/releases/download/v${DOCKER_MACHINE_SCALEWAY_VERSION}/docker-machine-driver-scaleway_${DOCKER_MACHINE_SCALEWAY_VERSION}_linux_amd64.zip" -O \
  && apt-get install -y unzip \
  && unzip docker-machine-driver-scaleway_${DOCKER_MACHINE_SCALEWAY_VERSION}_darwin_amd64.zip \
  && chmod +x docker-machine-driver-scaleway_${DOCKER_MACHINE_SCALEWAY_VERSION}_darwin_amd64/docker-machine-driver-scaleway \
  && mv docker-machine-driver-scaleway_${DOCKER_MACHINE_SCALEWAY_VERSION}_darwin_amd64/docker-machine-driver-scaleway /usr/local/bin/ \
  && apt-get purge -y unzip \
  && rm -rf docker-machine-driver-scaleway_${DOCKER_MACHINE_SCALEWAY_VERSION}_darwin_amd64/ \
  && rm -rf docker-machine-driver-scaleway_${DOCKER_MACHINE_SCALEWAY_VERSION}_darwin_amd64.zip \
  && apt-get clean

COPY overlay/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
