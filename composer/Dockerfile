# for correct container work, current host system user must be set in
# compose.yaml, otherwise laravel-development directory owner will be root

# base docker image
FROM ubuntu:latest

# set environment variable time zone for php installing
ENV TZ=Europe/Kyiv

# install PHP with xml sqlite3 extensions and composer
RUN apt update && apt install -y \
    php \
    php-xml \
    php-sqlite3 \
    composer \
    && apt clean

# create a working directory in container
WORKDIR /app

# remove the old directory and create Laravel project
ENTRYPOINT ["sh", "-c", "rm -rf laravel-development && composer create-project --prefer-dist laravel/laravel laravel-development"]