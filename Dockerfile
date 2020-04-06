ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

LABEL maintainer="Khoa Hoang"

ENV DEBIAN_FRONTEND noninteractive

USER root

ARG TZ=UTC
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
  echo ${TZ} > /etc/timezone
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "LANG=en_US.UTF-8" >> /etc/environment

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -yqq --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  autoconf automake curl git make vim gcc gettext \
  net-tools wget unzip vim zip

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

RUN apt-get clean && apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www
