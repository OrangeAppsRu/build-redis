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
    # В Ubuntu 16.04 существует бинарник redis-check-dump, которого в новой версии нет, но зато появился redis-check-rd
    sed -i 's@src/redis-check-dump@src/redis-check-rdb@g' redis-${REDIS_VERSION}/debian/redis-tools.install
    cd redis-${REDIS_VERSION}/

    /usr/bin/debuild -b -uc -us &
    traping
    exit 0
fi

exec "$@"
