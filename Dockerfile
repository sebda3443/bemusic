FROM php:8.2-apache

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurer Apache pour Fly.io
RUN a2enmod rewrite headers
COPY .docker/apache-fly.conf /etc/apache2/sites-available/000-default.conf

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers
COPY . .

# Installer les dépendances
RUN composer install --no-dev --optimize-autoloader
RUN npm install --only=production
RUN npm run build

# Configurer les permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Port pour Fly.io
EXPOSE 8080

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
