This is a development environment for the Laravel application with MySQL database in Docker containers.

Block-diagram of application:
<pre>
+-----------------+
| request from    |
| client browser  |
+-----------------+
         |
         V
+-----------------+
| nginx container |       +------------+    +------------+
| port 8080       |       | composer   |    | artisan    |
+-----------------+       | container  |    | container  |
         |                +------------+    +------------+
         V                          |             |
+-----------------+                 V             V
| php-fpm         |              +-----------------------+
| container       |------------->| "laravel-development" |
+-----------------+              | directory and         |
   |                             | SQLite files          |
   |   +----------------------+  | bind mounts           |
   |   | phpmyadmin container |  +-----------------------+
   |   | port 8090            |
   |   +----------------------+
   |        |
   V        V           +--------------------------------+
+-----------------+     | "laravel" database             |
| mysql           |---> | laravel-development-mysql-data |
| container       |     | volumes                        |
+-----------------+     +--------------------------------+
</pre>

System requirements:
linux kernel version 6.8.0-51-generic
docker engine version 27.5.0
docker compose version 2.32.3

Step 1 - building development environment.

First of all, rename the root directory to the name of your project, this is important because docker will use this name when building images.

For mysql database, change the root password in the secrets/mysql_root_password.txt. Exclude "secrets" directory from git commits in .gitignore file.

Up all development containers with composer create-project.
This is the default behavior and should be used in all standard cases.
!Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel project! It's Ok if you create a new project.
CUID=$(id -u) CGID=$(id -g) docker compose --profile create-project up -d

If you need up only development containers:
CUID=$(id -u) CGID=$(id -g) docker compose up -d

If you need up only composer container to create-project.
!Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel project! It's Ok if you create a new project.
CUID=$(id -u) CGID=$(id -g) docker compose up composer -d

If you need to delete the development environment: all containers and network.
The "laravel-development" directory and volume with the laravel database will not be deleted and will remain unchanged.
docker compose --profile delete-development-environment down

Step 2 - development process.

Development directory is "laravel-development". Open this directory in your IDE to start development. To see the result open in the browser "localhost:8080".
...

To connect mysql database ...
Migrate rollback and make ...
To attach to the artisan container:
docker exec -it artisan bash
Error in artisan container "I have no name!" is Ok, because attribute "user" in compose.yaml can't set the "name".

Step 3 - build an image from a finished project.
will be ...

Other
Restart php-fpm container after replacing index.php file:
docker restart php-fpm