# build argument for PHP version
ARG PHP_VERSION

# base docker image
FROM php:${PHP_VERSION}fpm

# install PHP extensions for databases: pdo, pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql

# build argument for Xdebug version
ARG XDEBUG_VERSION

# install and enable Xdebug PHP extension
RUN pecl install xdebug${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug

# create xdebug logs directory
RUN mkdir /xdebug-logs

# set and create a working directory in image
WORKDIR /app

# declare expose port
EXPOSE 9000
