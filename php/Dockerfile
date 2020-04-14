ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

RUN apk add --update --no-cache curl-dev wget git grep g++ make zip unzip \
  autoconf build-base icu-dev \
  libmemcached-dev libmcrypt-dev libxml2-dev \
  libtool libgsasl-dev libzip-dev \
  imagemagick-dev pcre-dev cyrus-sasl-dev supervisor

RUN pecl channel-update pecl.php.net \
  && pecl install memcached \
  && pecl install imagick \
  && pecl install mcrypt-1.0.3 \
  && pecl install xdebug \
  && docker-php-ext-enable memcached \
  && docker-php-ext-enable imagick \
  && docker-php-ext-enable mcrypt \
  && docker-php-ext-enable xdebug

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/ \
  && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

ARG TZ
RUN echo "date.timezone=${TZ:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

WORKDIR /var/www

USER www-data
