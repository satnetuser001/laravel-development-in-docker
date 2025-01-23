# base docker image
FROM php:8.3.15-cli

# set and create a working directory in image
WORKDIR /app

# copy laravel application to image in WORKDIR
COPY ./laravel-development /app

# run artisan server on port 8000 in container
ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
