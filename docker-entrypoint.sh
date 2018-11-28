#!/usr/bin/env bash

function traping() {
    PID=$!
    trap "kill -9 $PID" HUP INT QUIT TERM
    wait $PID
}

if [[ ${1} == 'build' ]]
then
    mkdir -p /home/user/build
    cd /home/user/build

    apt-get source redis-server=${DEB_VERSION} &
    traping

    xz -d redis_${DEB_VERSION_MAIN}-${DEB_VERSION_ADD}.debian.tar.xz -c | tar -x

    wget ${REDIS_URL} &
    traping

    tar xzf redis-${REDIS_VERSION}.tar.gz
    mv debian redis-${REDIS_VERSION}/
    rm -rf redis-${REDIS_VERSION}/debian/patches
    cp -fv /home/user/control redis-${REDIS_VERSION}/debian/
    cp -fv /home/user/changelog redis-${REDIS_VERSION}/debian/
    cd redis-${REDIS_VERSION}/

    /usr/bin/debuild -b -uc -us &
    traping
    exit 0
fi

exec "$@"
