#
# OPS LINUX
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
# @see https://github.com/aurelien-andre-weldom/ops-debian
#
FROM debian:buster-slim

ARG UID=1000
ARG GID=1000

ENV \
DEBIAN_VERSION="buster" \
DEBIAN_VARIANT="slim" \
SUPERVISOR_LOG_LEVEL="warn" \
SUPERVISOR_LOG_LEVEL="warn" \
SUPERVISOR_LOG_FILE="/proc/self/fd/1" \
SUPERVISOR_USERNAME="rootless" \
SUPERVISOR_PASSWORD="nopassword" \
SUPERVISOR_PORT="9001" \
SUPERVISOR_FILES="/etc/supervisor/conf.d/*.conf"

RUN set -eux; \
apt-get update; \
apt-get install -y --no-install-recommends \
software-properties-common \
apt-transport-https \
apt-utils \
ca-certificates \
lsb-release \
systemd \
supervisor \
gnupg \
gnupg1 \
gnupg2 \
wget \
curl \
jq

RUN set -eux; \
adduser -h /home/rootless -g "rootless" -D -u ${UID} rootless; \
echo "rootless:${UID}:${GID}" >> /etc/subuid; \
echo "rootless:${UID}:${GID}" >> /etc/subgid; \
echo "rootless:rootless:${UID}:${GID}:/rootless:/usr/bin" >> /etc/passwd; \
echo "rootless::${GID}:rootless" >> /etc/group

COPY --chown=rootless:rootless system .

RUN set -eux; \
mkdir -p \
/etc/supervisor \
/var/pid \
/var/run \
/var/lock \
/var/log \
/var/cache \
/var/lib \
/var/www; \
chmod 777 -R \
/etc/supervisor \
/var/pid \
/var/run \
/var/lock \
/var/log \
/var/cache \
/var/lib \
/var/www; \
chown rootless:rootless \
/etc/supervisor \
/etc/localtime \
/var/pid \
/var/run \
/var/lock \
/var/log \
/var/cache \
/var/lib \
/var/www

RUN set -eux; \
chmod +x -R \
/usr/bin/docker-*

WORKDIR /var/www

ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGQUIT

EXPOSE 9001

CMD ["supervisord"]

USER rootless
