ARG PHP_VERSION=7.4
FROM wordpress:php${PHP_VERSION}-apache

LABEL maintainer="Khoa Hoang"

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -yqq --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  autoconf automake curl git make vim gcc gettext net-tools wget zip unzip

RUN curl -s -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x /usr/local/bin/wp && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
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

RUN apt-get clean && apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www
