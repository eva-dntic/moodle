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

# Habilita mod_rewrite de Apache
RUN a2enmod rewrite

# Crea moodledata y asigna permisos correctos
RUN mkdir -p /var/www/moodledata && chown -R www-data:www-data /var/www/moodledata

# Ajusta max_input_vars para Moodle (requisito mínimo 5000)
RUN echo "max_input_vars = 5000" > /usr/local/etc/php/conf.d/max_input_vars.ini

# Copia el código fuente de Moodle
COPY . /var/www/html/

# Asigna permisos correctos a los archivos de Moodle
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
