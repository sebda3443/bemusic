#!/bin/bash
set -e

echo "📦 Installation des dépendances PHP..."
composer install --no-dev --optimize-autoloader

echo "🔑 Génération de la clé d'application..."
php artisan key:generate --force

echo "🔗 Création des liens de stockage..."
php artisan storage:link

echo "🚀 Publication des assets Horizon..."
php artisan horizon:publish

echo "📊 Installation des dépendances Node.js..."
npm ci --only=production

echo "🏗️  Build des assets..."
npm run build

echo "✅ Build terminé avec succès !"
