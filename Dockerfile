ARG PHP_VERSION=8.0
FROM php:${PHP_VERSION}-apache

LABEL maintainer="Khoa Hoang"

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -yqq --no-install-recommends --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  autoconf automake apt-utils iputils-ping build-essential curl git g++ make vim gcc gettext net-tools wget zip unzip \
  libzip-dev libbz2-dev libmemcached-dev libyaml-dev libicu-dev libmagick++-dev libssl-dev zlib1g-dev libmagickwand-dev libpq-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev

RUN docker-php-ext-install bcmath bz2 exif gd gettext intl pcntl pdo_mysql pdo_pgsql mysqli zip
RUN docker-php-ext-configure gd \
  --with-jpeg=/usr/include/ \
  --with-freetype=/usr/include/
RUN docker-php-ext-configure zip

RUN pecl install -o -f memcached mongodb redis yaml && \
  rm -rf /tmp/pear && \
  docker-php-ext-enable memcached mongodb redis yaml

# At the time of writing, the `imagick` library is not officially released for PHP 8 yet ( https://pecl.php.net/package/imagick ).
# This fix is just a workaround solution while waiting for their official release.
# RUN docker-php-ext-install imagick && docker-php-ext-enable imagick
RUN mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
    docker-php-ext-install imagick;

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -s -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x /usr/local/bin/wp

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh \
  && npm install -g yarn

COPY vhosts/vhost.conf /etc/apache2/sites-enabled/vhost.conf

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
  pecl install xdebug && docker-php-ext-enable xdebug \
;fi

ARG TIMEZONE=UTC
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  echo ${TIMEZONE} > /etc/timezone && \
  echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
  echo "LANG=en_US.UTF-8" >> /etc/environment

RUN a2enmod rewrite ssl

RUN apt-get clean && apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* && \
  rm /var/log/lastlog /var/log/faillog

VOLUME /var/www
WORKDIR /var/www

EXPOSE 80
EXPOSE 443
