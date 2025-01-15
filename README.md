This is a development environment for the Laravel application in Docker containers.

#to-do: block-diagram of application ?

System requirements:
linux kernel version 6.8.0-51-generic
docker engine version 27.5.0
docker compose version 2.32.3

First of all, rename the root directory to the name of your project, this is important because docker will use this name when building images.

Step 1
Up all development containers with composer create-project.
This is the default behavior and should be used in all standard cases.
!Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel project! It's Ok if you create a new project.
CUID=$(id -u) CGID=$(id -g) docker compose --profile create-project up -d

If you need up only development containers:
CUID=$(id -u) CGID=$(id -g) docker compose up -d

If you need up only composer container to create-project.
!Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel project! It's Ok if you create a new project.
CUID=$(id -u) CGID=$(id -g) docker compose up composer -d

If you need to delete all containers and network.
The "laravel-development" directory will not be deleted and will remain unchanged.
docker compose --profile delete-development-environment down

Step 2
to-do: describe development process

Step 3
to-do: build an image from a finished project

Other
Restart php-fpm container after replacing index.php file:
docker restart php-fpm