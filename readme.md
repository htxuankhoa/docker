# Overview

## Application path
This environment is setup to serve multi-projects at the `APPLICATIONS` path.

Example

```
~/dev
├── project1
└── project2
```

→ set the `APPLICATIONS` path is `~/dev`

## Mapping data & log between HOST & GUEST machine

All the MySQL data & Apache2 logs will be stored in the `<this_repo>/_synced` path by default.

You can change those paths as your need by changing these variables below

```
HOST_APACHE2_LOGS_PATH=path/to/HOST/logs/apache2
HOST_MYSQL_DATA_PATH=path/to/HOST/data/mysql
```

# Installation

Please **remember** to modify variables in the `.env` file before build containers.

```bash
$ cp .env.example .env

# Build images & containers
$ docker-compose up -d mysql php-fpm apache2 workspace
```

# Useful commands

```bash
# Re-build only a specific service
#    --no-deps: don't start linked services.
#    --build: build images before starting containers.
$ docker-compose up -d --build --force-recreate --no-deps <service_name>

# SSH to the workspace container to perform commands
$ docker exec -it workspace /bin/bash

# Restore the dumped database to the MySQL container from HOST machine
$ docker exec -i mysql mysql -uroot -psecret <db_name> < path/to/db_dumped.sql
```

**References**

- Timezone: UTC, Asia/Ho_Chi_Minh ( https://www.php.net/manual/en/timezones.php )

# License

[MIT license](https://opensource.org/licenses/MIT)
