# Описание
Docker образы для сборки **redis** под Ubuntu 16.04, 18.04.

## Сборка
Собранные пакеты помещаются в директорию `/home/user/build` внутри контейнера. Также сборка выполняется от имени пользователя с `uid` 1001. Поэтому у этого пользователя должны быть права на запись в эту директорию.

Таким образом нам нужно создать какую-либо папку, дать ей полные права и прокинуть внутрь контейрера в директорию `/home/user/build`.

При сборке в changelog добавляется новая собираемая версия, таким образом версия пакета будет взята из собираемой версии redis. Более подробно вы можете уточнить в скрипте **docker-entrypoint.sh**. Про то как изменить версию redis смотрите раздел [Собрать определенную версию](#собрать-определенную-версию)

Помимо `control` и `changelog` **docker-entrypoint.sh** также копирует конфиг для **redis** (`redis.conf`). Так как некоторые параметры по умолчанию странные, а именно `damonisze no` при том что в systemd конфиге стоит `type=forking`, в итоге при установке redis, получаем бесконечное зависание на `systemctl start redis-server`.

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

**Заметьте**: docker-entrypoint в changelog тоже добавляет описание поверх тех, что уже лежат в репозитории, во время сборки. То есть в changelog следует добавлять напирмер обновления из changelog официального пакета. Посмотреть его можно таким образом:
```bash
# Нужно чтобы redis-server был установлен из официальной репы
apt-get changelog redis-server
```

Обновите образы:
```bash
docker pull tapclap/redis-build:ubuntu18.04
docker pull tapclap/redis-build:ubuntu16.04
```

Теперь последующие сборки, будут создавать пакеты с новым описанием.

## Сборка образов вручную
Также можно собрать образы самому, а затем запушить на hub.docker.com

Для образа, который будет собирать пакеты для Ubuntu16.04:
```bash
docker build -t redis-build:ubuntu16.04 -f ./Dockerfile_16.04 ./

```

Для образа, который будет собирать пакеты для Ubuntu18.04:
```bash
docker build -t redis-build:ubuntu18.04 -f ./Dockerfile_18.04 ./

```

Теперь у Вас есть локально собранные образы, и Вы можете собирать пакеты **redis** с помощью них:
```bash
mkdir build
chmod 777 build
docker run --rm -v $PWD/build:/home/user/build redis-build:ubuntu16.04 build
```

### Пуш локально созданных образов на hub.docker.com
Создайте тэг, который укажет что образ принадлежит аккаунту **tapclap**.
```bash
docker tag redis-build:ubuntu16.04 tapclap/redis-build:ubuntu16.04
docker tag redis-build:ubuntu18.04 tapclap/redis-build:ubuntu18.04

```
Пуш
```bash
docker push tapclap/redis-build:ubuntu16.04
docker push tapclap/redis-build:ubuntu18.04
```
