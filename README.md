## 👋 Welcome to systemd 🚀  

systemd README  
  
  
## Run container

```shell
dockermgr update systemd
```

### via command line

```shell
docker pull casjaysdevdocker/systemd:latest && \
docker run -d \
--privileged \
--restart always \
--name casjaysdevdocker-systemd \
--hostname casjaysdev-systemd \
-e TZ=${TIMEZONE:-America/New_York} \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
-v $HOME/.local/share/docker/storage/systemd/systemd/data:/data \
-v $HOME/.local/share/docker/storage/systemd/systemd/config:/config \
casjaysdevdocker/systemd:latest
```

### via docker-compose

```yaml
version: "2"
services:
  systemd:
    image: casjaysdevdocker/systemd
    container_name: systemd
    privileged: true
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
      - $HOME/.local/share/docker/storage/systemd/data:/data:z
      - $HOME/.local/share/docker/storage/systemd/config:/config:z
    ports:
      - 
    restart: always
```

## Authors  

🤖 Jason Hempstead: [Github](https://github.com/Jason Hempstead) [Docker](https://hub.docker.com/r/Jason Hempstead) 🤖  
⛵ CasjaysDevdDocker: [Github](https://github.com/casjaysdev) [Docker](https://hub.docker.com/r/casjaysdevdocker) ⛵  
