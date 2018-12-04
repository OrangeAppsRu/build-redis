FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

ENV REDIS_VERSION 5.0.2
ENV DEB_VERSION_MAIN 3.0.6
ENV DEB_VERSION_ADD 1

ENV DEB_VERSION 2:${DEB_VERSION_MAIN}-${DEB_VERSION_ADD}

RUN sed  -i 's/# deb-src/deb-src/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        dpkg-dev \
        devscripts \
        build-essential \
        fakeroot \
        debhelper \
        libssl-dev \
        libpcre3-dev \
        zlib1g-dev \
        quilt \
        vim \
        curl \
        wget && \
    apt-get build-dep -y redis-server

RUN useradd -m user && \
    mkdir -p /home/user && \
    chown user:user -R /home/user

USER user
WORKDIR /home/user

COPY --chown=user:user control_16.04 /home/user/control
COPY --chown=user:user changelog_16.04 /home/user/changelog
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY Dockerfile_16.04 /Dockerfile

ENTRYPOINT ["/docker-entrypoint.sh"]
