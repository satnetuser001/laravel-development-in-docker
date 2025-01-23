# base docker image
FROM php:8.3.15-fpm

# install PHP extensions for databases: pdo, pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql

# set and create a working directory in image
WORKDIR /app

# copy laravel application to image in WORKDIR
COPY ./laravel-development /app

# set laravel application owner to PHP-FPM process
RUN chown -R www-data:www-data /app

# declare expose port
EXPOSE 9000
