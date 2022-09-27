FROM php:7.3-fpm
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install redis-4.0.1 \
    && docker-php-ext-enable redis

RUN docker-php-ext-install pdo pdo_mysql

    # Install PHPUnit
RUN cd /tmp && curl -LO https://phar.phpunit.de/phpunit.phar > phpunit.phar && \
    chmod +x phpunit.phar && \
    mv /tmp/phpunit.phar /usr/local/bin/phpunit

RUN apt-get update && \
    apt-get install -y --no-install-recommends zip

RUN apt-get update && \ 
    apt-get install -y \
    libzip-dev \
    unzip

  



RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN docker-php-ext-install pcntl    
 

# RUN DEBIAN_FRONTEND=noninteractive apt-get update -y \
#     && echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list \
#     && mkdir -p /usr/share/man/man1 \
#     && DEBIAN_FRONTEND=noninteractive apt-get update -y \
#     && apt install -t jessie-backports  openjdk-8-jre-headless ca-certificates-java

# RUN DEBIAN_FRONTEND=noninteractive apt-get update \
#     && apt-get install -y \
#     ant  

    
RUN apt update
RUN apt upgrade -y
RUN apt install -y libxslt-dev



RUN docker-php-ext-install xsl

RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev

RUN docker-php-ext-install zip  

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libxslt-dev
    
RUN docker-php-ext-install xsl

# RUN curl --silent --show-error https://getcomposer.org/installer | php \
#     && chmod +x composer.phar \
#     && mv composer.phar /usr/local/bin/composer  

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN docker-php-ext-install sockets   


# Install various PHP extensions
RUN docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install \
        bcmath \
        intl \
        mbstring \
        mysqli \
        pcntl \
        pdo_mysql \
        soap \
        sockets \
        zip \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache

RUN echo "memory_limit = 1024M" >> /usr/local/etc/php/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --version=1.10.16 --install-dir=/usr/local/bin/ --filename=composer

RUN yes | pecl install xdebug

RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=false" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.auto_trace=true" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.max_nesting_level=1500" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/xdebug.ini


RUN git clone https://github.com/edenhill/librdkafka.git /tmp/librdkafka && \
  cd /tmp/librdkafka/ && \
  ./configure && \
  make && \
  make install


RUN  pecl install rdkafka && \
  echo "extension=rdkafka.so" > /usr/local/etc/php/conf.d/rdkafka.ini

