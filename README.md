# OPS Linux

Create your linux debian templates in an automated way 

Include supervisord stack

@see : http://supervisord.org

### Concept

![concept](docs/concept.png)

### Terraform Versions

```json
{
  "100.0.1": {
    "variants": [
      "bullseye"
    ],
    "version": "100.0.1"
  },
  "100.0.0": {
    "variants": [
      "bullseye"
    ],
    "version": "100.0.0"
  }
}
```

Like php

@see https://github.com/docker-library/php/blob/master/Dockerfile-linux.template

### Requirements

```shell
# Install JQ
sudo apt-get install jq
```

### Usage

Edit dockerfile.template

```shell
# Update all versions
MASTER_VERSION=100.0.1 \
MASTER_VARIANT=bullseye \
bash run-update.sh
```

```shell
# Build all docker images
MASTER_VERSION=100.0.1 \
MASTER_VARIANT=bullseye \
bash run-build.sh
```

### Env Configuration

```dotenv
SUPERVISOR_LOG_LEVEL="warn" \
SUPERVISOR_LOG_FILE="/proc/self/fd/1" \
SUPERVISOR_USERNAME="rootless" \
SUPERVISOR_PASSWORD="nopassword" \
SUPERVISOR_PORT="9001" \
SUPERVISOR_FILES="/etc/supervisor/conf.d/*.conf"
```

### Test

```shell
docker run -it --rm --name ops-debian -p 9001:9001 ops-debian/debian:latest
```

@see http://localhost:9001

### Supervisor

```shell
docker run -it --rm --name ops-debian ops-debian/debian:latest supervisorctl help
```

### Terraform

```dockerfile
FROM ops-debian/debian:latest

USER root

COPY --chown=rootless:rootless docker/docker-*.sh /usr/bin

RUN chmod +x /usr/bin/docker-*

RUN set -eux; \
echo "docker-entrypoint-custom-1.sh" >> /docker-entrypoint.list; \
echo "docker-entrypoint-custom-2.sh" >> /docker-entrypoint.list

RUN set -eux; \
echo "docker-health-custom-1.sh" >> /docker-health.list; \
echo "docker-health-custom-2.sh" >> /docker-health.list

COPY --chown=rootless:rootless supervisor/*.conf /etc/supervisor/conf.d

ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGQUIT

EXPOSE 9001

CMD ["supervisord"]

USER rootless
```
