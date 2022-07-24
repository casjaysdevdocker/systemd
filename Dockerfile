FROM casjaysdevdocker/debian:latest as build

ARG LICENSE=WTFPL \
  IMAGE_NAME=systemd \
  TIMEZONE=America/New_York \
  PORT=

ENV SHELL=/bin/bash \
  TERM=xterm-256color \
  HOSTNAME=${HOSTNAME:-casjaysdev-$IMAGE_NAME} \
  TZ=$TIMEZONE

RUN echo 'debconf debconf/frontend select teletype' | debconf-set-selections

RUN mkdir -p /bin/ /config/ /data/ && \
  rm -Rf /bin/.gitkeep /config/.gitkeep /data/.gitkeep && \
  install_packages \
  systemd \
  systemd-sysv \
  cron && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  /var/log/alternatives.log \
  /var/log/apt/history.log \
  /var/log/apt/term.log \
  /var/log/dpkg.log  \
  /etc/machine-id \
  /var/lib/dbus/machine-id && \
  systemctl mask --   \
  dev-hugepages.mount \
  sys-fs-fuse-connections.mount && \


COPY ./bin/. /usr/local/bin/
COPY ./config/. /config/
COPY ./data/. /data/

FROM scratch
ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')"

LABEL org.label-schema.name="systemd" \
  org.label-schema.description="Containerized version of systemd" \
  org.label-schema.url="https://hub.docker.com/r/casjaysdevdocker/systemd" \
  org.label-schema.vcs-url="https://github.com/casjaysdevdocker/systemd" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="$LICENSE" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="latest" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>"

ENV SHELL="/bin/bash" \
  TERM="xterm-256color" \
  HOSTNAME="casjaysdev-systemd" \
  TZ="${TZ:-America/New_York}" \
  container="docker" 

STOPSIGNAL SIGRTMIN+3

WORKDIR /root

VOLUME [ "/root","/config","/data","/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

EXPOSE $PORT

COPY --from=build /. /

HEALTHCHECK CMD [ "/usr/local/bin/entrypoint-systemd.sh", "healthcheck" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint-systemd.sh" ]
CMD [ "/sbin/init" ]

