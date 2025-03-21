FROM php:7.2-apache

RUN a2enmod rewrite

RUN set -xe \
    && apt-get update \
    && apt-get install -y libfreetype6-dev libpng-dev libjpeg-dev libpq-dev libxml2-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr \
    && docker-php-ext-install gd mbstring mysqli pgsql soap \
    && rm -rf /var/lib/apt/lists/*

ENV MANTIS_VERSION=2.25.2
ENV MANTIS_MD5=0fbb55aa1f12ba4be8436a444465d5b1
ENV MANTIS_URL=https://sourceforge.net/projects/mantisbt/files/mantis-stable/${MANTIS_VERSION}/mantisbt-${MANTIS_VERSION}.tar.gz
ENV MANTIS_FILE=mantisbt.tar.gz

RUN set -xe \
    && curl -fSL ${MANTIS_URL} -o ${MANTIS_FILE} \
    && echo "${MANTIS_MD5}  ${MANTIS_FILE}" | md5sum -c \
    && tar -xz --strip-components=1 -f ${MANTIS_FILE} \
    && rm ${MANTIS_FILE} \
    && chown -R www-data:www-data .

RUN set -xe \
    && ln -sf /usr/share/zoneinfo/America/Vancouver /etc/localtime \
    && touch /usr/local/etc/php/conf.d/mantis.ini \
    && echo 'date.timezone = "America/Vancouver"' >> /usr/local/etc/php/conf.d/mantis.ini \
    && echo 'log_errors = 1' >> /usr/local/etc/php/conf.d/mantis.ini \
    && echo 'upload_max_filesize = 20M' >> /usr/local/etc/php/conf.d/mantis.ini \
    && echo 'post_max_size = 21M' >> /usr/local/etc/php/conf.d/mantis.ini
