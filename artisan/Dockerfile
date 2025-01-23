# base docker image
FROM php:8.3.15-cli

# install PHP extensions for databases: pdo, pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql

# set and create a working directory in image
WORKDIR /app

# infinite task to prevent container from stopping
ENTRYPOINT ["sleep", "infinity"]