# build argument for PHP version
ARG PHP_VERSION

# base docker image
FROM php:${PHP_VERSION}cli

# install PHP extensions for databases: pdo, pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql

# set and create a working directory in image
WORKDIR /app

# infinite task to prevent container from stopping
ENTRYPOINT ["sleep", "infinity"]