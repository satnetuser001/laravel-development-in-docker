<?php
echo "<h1>If you see this page it means that the container with composer has not been \"Up\".</h1><br>\n";
echo "<h1>To fix it, exec in the directory with compose.yaml file \"CUID=$(id -u) CGID=$(id -g) docker compose up composer -d\".</h1><br>\n";
echo "<h1>Then restart the php-fpm container \"docker restart php-fpm\".</h1><br>\n";