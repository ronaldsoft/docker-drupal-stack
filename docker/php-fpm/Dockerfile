FROM php:7.3-fpm

# Dependencies
RUN apt-get update && apt-get install -y --fix-missing \
  libc-dev \
  sendmail \
  libpng-dev \
  graphviz \
  zip \
  curl \
  pkg-config \
  nano \
  cron \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libxml2-dev \
  libpq-dev \
  libxslt1-dev \
  libcurl4-openssl-dev \
  libmcrypt-dev \
  libyaml-dev \
  libicu-dev \
  libzip-dev \
  libbz2-dev \
  linux-libc-dev \
  libpspell-dev \
  libldap2-dev \
  libedit-dev \
  libreadline-dev \
  libc-client-dev \
  libkrb5-dev \
  libmemcached-dev \
  zlib1g-dev \
  wget \
  unzip \
  imagemagick \
  libmagickwand-dev \
  libmagickcore-dev \
  git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    ln -s ~/.composer/vendor/bin/drush /usr/local/bin/drush

# Change upload file size
RUN echo "upload_max_filesize = 500M\n" \
         "post_max_size = 500M\n" \
         > /usr/local/etc/php/conf.d/maxsize.ini

# php.ini Drupal requirements
RUN echo "memory_limit = 2048M\n" \
         "display_errors = On\n" \
         "display_startup_errors = On\n" \
         "error_reporting = E_ALL\n" \
         "post_max_size = 500M\n" \
         "max_execution_time = 300\n" \
         > /usr/local/etc/php/conf.d/drupal.ini

# Install Drush
RUN composer global require drush/drush
    #composer global update

# Copy and run entrypoint
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # For backwards compatibility.
#ENTRYPOINT ["./docker-entrypoint.sh"]
WORKDIR "/var/www/"

# Install PHP extensions
RUN pecl install -Z xdebug-2.9.2 \
  && pecl install mcrypt-1.0.2 \
  && docker-php-ext-install bz2 \
  && docker-php-ext-install calendar \
  && docker-php-ext-install ctype \
  && docker-php-ext-install mbstring \
  && docker-php-ext-install xsl \
  && docker-php-ext-install intl \
  && docker-php-ext-install exif \
  && docker-php-ext-install bcmath \
  && docker-php-ext-install gd \
  && docker-php-ext-install opcache \
  && docker-php-ext-install mysqli \
  && docker-php-ext-install pdo \
  && docker-php-ext-install pcntl \
  && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
  && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir==/usr/include/ \
  && docker-php-ext-install pdo_mysql \
  && docker-php-ext-enable mcrypt \
  && docker-php-ext-enable gd \
  && docker-php-ext-enable opcache \
  && docker-php-ext-enable mysqli \
  && docker-php-ext-enable pdo_mysql \
  && docker-php-ext-enable xdebug

# Clean repository
RUN apt-get clean && rm -rf /var/lib/apt/lists/*