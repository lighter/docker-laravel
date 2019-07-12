FROM php:7.2-fpm

COPY ./php7.2/php.ini /usr/local/etc/php/

RUN mkdir -p /var/log/php_log
RUN mkdir -p /var/backups

ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Fix: W: Failed to fetch http://deb.debian.org/debian/dists/jessie-updates/InRelease  Unable to find expected entry 'main/binary-amd64/Packages' in Release file (Wrong sources.list entry or malformed file)
# RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    libsqlite3-dev \
    vim \
    cron \
    procps \
    htop \
    telnet \
    git \

    # iconv
    && docker-php-ext-install -j$(nproc) iconv \

    # mcrypt
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \

    # redis
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \

    # pgsql
    && apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql \

    # sqlite
    && docker-php-ext-install pdo_sqlite \

    && docker-php-ext-install mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \

    # xdebug
    && pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini

# composer install 需要用到的 package
RUN apt-get install zip unzip

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs
RUN npm install --global yarn

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron
RUN crontab /etc/cron.d/backup-cron

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 9000 9001

ENTRYPOINT /entrypoint.sh
