FROM php:8.2-apache

# Instala las dependencias necesarias para Moodle y PostgreSQL
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

# Crea el directorio de datos de Moodle
RUN mkdir -p /var/www/moodledata

# Copia los archivos de tu proyecto a la imagen (ajusta el contexto si tu código no está en la raíz)
COPY . /var/www/html/

# Permisos correctos para Moodle y moodledata
RUN chown -R www-data:www-data /var/www/html /var/www/moodledata \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/moodledata -type d -exec chmod 770 {} \; \
    && find /var/www/moodledata -type f -exec chmod 660 {} \;

# Configuración PHP recomendada para Moodle
RUN echo "max_input_vars = 5000" > /usr/local/etc/php/conf.d/max_input_vars.ini \
    && echo "zend.exception_ignore_args = On" > /usr/local/etc/php/conf.d/zend.exception_ignore_args.ini

EXPOSE 80

CMD ["apache2-foreground"]
