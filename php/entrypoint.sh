#!/bin/sh

/etc/init.d/cron start

chown -R www-data:www-data /var/www/html
docker-php-entrypoint php-fpm
