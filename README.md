### This is a development environment for the Laravel application with MySQL database in Docker containers.

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

### Step 1 - building development environment.

Pull this application from the GitHub repository:
```bash
git clone https://github.com/satnetuser001/laravel-development-in-docker.git
```
Rename the root directory "laravel-development-in-docker" to the name of your project, this is important because docker will use this name when building images.

For mysql database, change the root password in the secrets/mysql_root_password.txt. Exclude "secrets" directory from git commits in .gitignore file.

Up all development containers with composer create-project.  
This is the default behavior and should be used in all standard cases.  
#### !Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel project! It's Ok if you create a new project.  
```bash
CUID=$(id -u) CGID=$(id -g) docker compose --profile create-project up -d
```

If you need up only development containers:  
```bash
CUID=$(id -u) CGID=$(id -g) docker compose up -d
```

If you need up only composer container to create-project.  
#### !Warning! All data in "laravel-development" directory will be deleted and replaced with the new Laravel project! It's Ok if you create a new project.  
```bash
CUID=$(id -u) CGID=$(id -g) docker compose up composer -d
```

If you need to delete the development environment: all containers and network.  
The "laravel-development" directory and volume with the laravel database will not be deleted and will remain unchanged.  
```bash
docker compose --profile delete-development-environment down
```

### Step 2 - development process.

Development directory is "laravel-development". Open this directory in your IDE to start development. To see the result open in the browser "localhost:8080".  
To see the phpMyAdmin page open in the browser "localhost:8090". Use "root" for the Username and value from the file "secrets/mysql_root_password.txt" for the Password.

Setting up a connection between Laravel and MySQL database. By default, Laravel comes with a SQLite database. So it needs to take several next steps to replace the database.

Attach to the artisan container:  
```bash
docker exec -it artisan bash
```
Error in artisan container "I have no name!" is Ok, because attribute "user" in compose.yaml can't set the "name".

In the artisan container make a rollback migration for the SQLite database:  
```php
php artisan migrate:rollback
```

In IDE edit .env file for MySQL database:
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

### Step 3 - build an image from a finished project.  
will be ...

### Other  
Restart php-fpm container after replacing index.php file.  
```bash
docker restart php-fpm
```

CUID=$(id -u) CGID=$(id -g) - describe what is this?