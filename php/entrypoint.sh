#!/bin/sh

/etc/init.d/cron start
docker-php-entrypoint php-fpm
