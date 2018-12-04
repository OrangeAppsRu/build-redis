# Описание
Docker образы для сборки **redis** под Ubuntu 16.04, 18.04.

## Сборка
Собранные пакеты помещаются в директорию `/home/user/build` внутри контейнера. Также сборка выполняется от имени пользователя с `uid` 1001. Поэтому у этого пользователя должны быть права на запись в эту директорию.

Таким образом нам нужно создать какую-либо папку, дать ей полные права и прокинуть внутрь контейрера в директорию `/home/user/build`.

Например:
```bash
mkdir build
chmod 777 build
docker run --rm -v $PWD/build:/home/user/build tapclap/redis-build-ubuntu16.04 build
```

Если все прошло хорошо, в папке `build` будут нужные нам пакеты.

### Сборка под Ubuntu 18.04

```bash
mkdir build
chmod 777 build
docker run --rm -v $PWD/build:/home/user/build tapclap/redis-build-ubuntu18.04 build
```

