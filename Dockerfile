FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    libpq-dev \
    libicu-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd xml zip mysqli pdo pdo_mysql pdo_pgsql pgsql intl exif soap opcache

RUN a2enmod rewrite

RUN mkdir -p /var/www/moodledata

COPY . /var/www/html/

# Asegura permisos correctos en html y moodledata para el usuario www-data
RUN chown -R www-data:www-data /var/www/html /var/www/moodledata \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/moodledata -type d -exec chmod 770 {} \; \
    && find /var/www/moodledata -type f -exec chmod 660 {} \;

RUN echo "max_input_vars = 5000" > /usr/local/etc/php/conf.d/max_input_vars.ini

EXPOSE 80

CMD ["apache2-foreground"]
