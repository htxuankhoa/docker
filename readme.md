# Overview

This environment is setup to serve multi-projects at the `APPLICATIONS` path.

Example

```
~/dev
├── project1
└── project2
```

→ set the `APPLICATIONS` path is `~/dev`

All the MySQL data & Apache2 logs will be stored in the `./_synced` path.

You can change those paths as your need by changing these variables below

```
HOST_APACHE2_LOGS_PATH=./_synced/logs/apache2
HOST_MYSQL_DATA_PATH=./_synced/data/mysql
```

# Installation

Please remember to modify the `.env` file before build containers.

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

$ docker exec -it workspace /bin/bash

$ docker exec -i mysql mysql -uroot -psecret db_name < path/to/db_dumped.sql
```

**References**

- Timezone: UTC, Asia/Ho_Chi_Minh ( https://www.php.net/manual/en/timezones.php )

# License

[MIT license](https://opensource.org/licenses/MIT)
