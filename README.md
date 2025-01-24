### This is a development environment for the Laravel application with MySQL database in Docker containers.

Block-diagram of development environment:
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
+-----------------+              | directory with        |
   |                             | SQLite files          |
   |   +----------------------+  | bind mount            |
   |   | phpmyadmin container |  +-----------------------+
   |   | port 8090            |
   |   +----------------------+
   |        |
   V        V           +--------------------------------+
+-----------------+     | "laravel" database             |
| mysql           |---> | laravel-development-mysql-data |
| container       |     | volume                         |
+-----------------+     +--------------------------------+
</pre>

System requirements:  
linux kernel version 6.8.0-51-generic  
docker engine version 27.5.0  
docker compose version 2.32.3  
unoccupied ports 8080 8090  

### Step 1 - building development environment.

Pull this application from the GitHub repository:
```bash
git clone https://github.com/satnetuser001/laravel-development-in-docker.git
```
Rename the root directory "laravel-development-in-docker" to the name of your project, this is important because docker will use this name when building images.

Optional step: for mysql database, change the root password in the file "secrets/mysql_root_password.txt". Exclude "secrets" directory from git commits in ".gitignore" file.

Up all development containers with composer create-project.  
This is the default behavior and should be used in all standard cases.  
!Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel application! It's Ok if you create a new application.  
```bash
CUID=$(id -u) CGID=$(id -g) docker compose --profile create-project up -d
```

If you need up only development containers:  
```bash
CUID=$(id -u) CGID=$(id -g) docker compose up -d
```

If you need up only composer container to create-project.  
!Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel application! It's Ok if you create a new application.  
```bash
CUID=$(id -u) CGID=$(id -g) docker compose up composer -d
```

If you need to delete the development environment: all containers and network.  
The "laravel-development" directory and volume with the laravel database will not be deleted and will remain unchanged.  
```bash
docker compose --profile delete-development-environment down
```

### Step 2 - development process.

Development directory is "laravel-development". Open this directory in your IDE to start development. To see the result open in the browser [localhost:8080](http://localhost:8080).  
To see the phpMyAdmin page open in the browser [localhost:8090](http://localhost:8090). Use "root" for the Username and value from the file "secrets/mysql_root_password.txt" for the Password.

Setting up a connection between Laravel and MySQL database. By default, Laravel 11 uses a SQLite database. So it needs to take several next steps to replace the database.

Attach to the artisan container:  
```bash
docker exec -it artisan bash
```
Note: error in artisan container "I have no name!" is Ok, because attribute "user" in compose.yaml can't set the "name" from your host.

In the artisan container make a rollback migration for the SQLite database:  
```php
php artisan migrate:rollback
```

In IDE edit "laravel-development/.env" file for MySQL database:
<pre>
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=1077
</pre>
Note: DB_PASSWORD must be value from the file "secrets/mysql_root_password.txt".

In the artisan container make a migration for the MySQL database:  
```php
php artisan migrate
```

### Step 3 - build a Laravel application image after finishing development.

It is supposed that the production environment architecture is similar to the following block-diagram:
<pre>
+-----------------+
| request from    |
| client browser  |
+-----------------+
         |
         V
+-----------------+
| nginx container |
| port 80         |
+-----------------+
   |                                          +---------------------------------+
   |    +---------------+    +-----------+    | "laravel-1" database            |
   |--->| Laravel-1 app |--->| mysql-1   |--->| laravel-production-mysql-data-1 |
   |    | container     |    | container |    | volume                          |
   .    +---------------+    +-----------+    +---------------------------------+
   .
   .                                          +---------------------------------+
   |    +---------------+    +-----------+    | "laravel-N" database            |
   |--->| Laravel-N app |--->| mysql-N   |--->| laravel-production-mysql-data-N |
        | container     |    | container |    | volume                          |
        +---------------+    +-----------+    +---------------------------------+
</pre>

Prepare your Laravel application for deployment according to the [documentation](https://laravel.com/docs/11.x/deployment).  
Set environment variables in "laravel-development/config" directory and "laravel-development/.env" file for production.

To build an image for a production environment, exec in the root directory of the project:
```bash
docker build --tag your-docker-hub-name/image-name:latest --file ./build-app/production.Dockerfile .
```
Note: replace "your-docker-hub-name" and "image-name" on yours.

If you want to build a stand-alone container from your application, exec in the root directory of the project:
```bash
docker build --tag image-name:latest --file ./build-app/stand-alone.Dockerfile .
```
Note: make sure that the database files, such as SQLite, are located within the application in "laravel-development" directory.  
Note: an image built on "stand-alone.Dockerfile" will have only SQLite DBMS, so you need to add the required DBMS to "stand-alone.Dockerfile" if needed.

#### Other

Recreate the Laravel application using the existing composer container.  
!Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel application!
```bash
docker container start composer
```

Restart php-fpm container after replacing "laravel-development/public/index.php" file.  
```bash
docker restart php-fpm
```

CUID=$(id -u) CGID=$(id -g) - setting in the images the name ID and group ID of the current user of the host system to set the correct owner for the application files.

The composer image is not used because for some reason it doesn't work correctly with my internet provider.