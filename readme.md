# Overview

![Local Docker screenshot](screenshot.png)

## Application path
This environment is setting up to serve multi-projects at the `APPLICATIONS` path.

Example

```
~/dev
├── project1
└── project2
```

→ set the `APPLICATIONS` path is `~/dev`

# Installation

Please **remember** to modify variables in the `.env` file before build containers.

```bash
$ cp .env.example .env

# Build images & containers
$ docker-compose up -d web db
```

# Useful commands

```bash
# Re-build only a specific service
#    --no-deps: don't start linked services.
#    --build: build images before starting containers.
$ docker-compose up -d --build --force-recreate --no-deps <service_name>

# SSH to the workspace container to perform commands
$ docker exec -it web /bin/bash

# Restore the dumped database to the MySQL container from HOST machine
$ docker exec -i db mysql -uroot -psecret <db_name> < path/to/db_dumped.sql

# clean up the components if needed
$ docker container prune
$ docker image prune
$ docker network prune
$ docker volume prune

# resolve the port was allocated error
# Example error message: "Bind for 0.0.0.0:443 failed: port is already allocated"
$ docker-compose down
$ sudo lsof -i -P -n | grep 443
$ kill -9 <process id>
$ docker-compose up

# find php.ini path
$ php -info | grep 'php.ini'
```

**References**

- Timezone: UTC, Asia/Ho_Chi_Minh ( https://www.php.net/manual/en/timezones.php )

# License

[MIT license](https://opensource.org/licenses/MIT)
