FROM php:7.4-fpm-alpine

RUN apk update && \
    apk add --no-cache postgresql-dev curl

RUN apk add --no-cache $PHPSIZE_DEPS build-base autoconf libzip-dev && \
    docker-php-ext-install opcache pgsql pdo_pgsql && \
    apk del --no-cache $PHPSIZE_DEPS build-base autoconf zlib-dev

ADD . /var/app

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN cd /var/app \
    && COMPOSER_ALLOW_SUPERUSER=1 composer install -n --no-progress --prefer-dist \
    && COMPOSER_ALLOW_SUPERUSER=1 composer dump --optimize

RUN rm /usr/local/bin/composer

WORKDIR /var/app
