# For correct container work, current host system user must be set in
# compose.yaml, otherwise laravel-development directory owner will be root.
# Also, the time zone environment variable must be set in compose.yam to
# install php without interactive questionsl.

# base docker image
FROM ubuntu:latest

# install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl

# add PHP repository
RUN add-apt-repository -y ppa:ondrej/php

# build argument for PHP version
ARG PHP_VERSION

# install PHP extensions required for Composer and Laravel installation
RUN apt-get update && apt-get install -y \
    php${PHP_VERSION} \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-sqlite3 \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-common

# build argument for Composer version
ARG COMPOSER_VERSION

# install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer${COMPOSER_VERSION};

# clearing cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# set and create a working directory in image
WORKDIR /app

# build argument for Laravel version
ARG LARAVEL_VERSION

# remove the old directory and create new Laravel project
ENTRYPOINT ["sh", "-c", "rm -rf laravel-development && composer create-project --prefer-dist laravel/laravel${LARAVEL_VERSION} laravel-development"]
