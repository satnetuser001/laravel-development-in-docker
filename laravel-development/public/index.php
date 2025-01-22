<?php
echo "<h1>If you see this page it means that the container with composer has not been \"Up\".</h1>  \n";
echo "<h1>To fix it, exec in the directory with compose.yaml file \"CUID=$(id -u) CGID=$(id -g) docker compose up composer -d\".</h1>  \n";