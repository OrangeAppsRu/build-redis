# Описание
Docker образы для сборки **redis** под Ubuntu 16.04, 18.04.

## Сборка
Собранные пакеты помещаются в директорию `/home/user/build` внутри контейнера. Также сборка выполняется от имени пользователя с `uid` 1001. Поэтому у этого пользователя должны быть права на запись в эту директорию.

Таким образом нам нужно создать какую-либо папку, дать ей полные права и прокинуть внутрь контейрера в директорию `/home/user/build`.

Например:
```bash
mkdir build
chmod 777 build
docker run --rm -v $PWD/build:/home/user/build tapclap/redis-build:ubuntu16.04 build
```

Если все прошло хорошо, в папке `build` будут нужные нам `*.deb` пакеты.

### Сборка под Ubuntu 18.04

```bash
mkdir build
chmod 777 build
docker run --rm -v $PWD/build:/home/user/build tapclap/redis-build:ubuntu18.04 build
```

### Собрать определенную версию.
Версия по умолчанию указана в `Dockerfile` в перемнной окружения `REDIS_VERSION`. Для того, чтобы ее переопределить, запустите со следующим параметром `--env 'REDIS_VERSION=нужная_версия'`. Например:

```bash
mkdir build
chmod 777 build
docker run --rm -v $PWD/build:/home/user/build --env 'REDIS_VERSION=5.0.1' tapclap/redis-build:ubuntu16.04 build
```
**Замечание:** Архив скачивается из http://download.redis.io/releases/. Указанная вами версия должна там существовать.

## Обновление описания и changelog
Описание пакетов и changelog находятся в соотвесвтующих файлах (для Ubuntu 16.04: `control_16.04`, `changelog_16.04`. Для Ubuntu 18.04:  `control_16.04`, `changelog_16.04`).

**Будьте осторожны. `changelog` файл имеет определенную структуру. Постарайтесь ее соблюдать. Важен даже указываемый формат времени**

Просто добавьте, то что вам требуется и запуште изминения в репозиторий. Образы пересоберутся по тригеру.

Обновите образы:
```bash
docker pull tapclap/redis-build:ubuntu18.04
docker pull tapclap/redis-build:ubuntu16.04
```

Теперь последующие сборки, будут создавать пакеты с новым описанием.