# CyberShield — déploiement Render / Docker
# L'application PHP tourne avec Apache et utilise database.sqlite fournie.
FROM php:8.2-apache

# libsqlite3-dev fournit sqlite3.pc, requis par pdo_sqlite.
# PDO est déjà présent dans l'image : on n'installe que les drivers.
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev \
    && docker-php-ext-install pdo_mysql pdo_sqlite \
    && rm -rf /var/lib/apt/lists/*

# Base SQLite hors de la racine web (pas téléchargeable par un visiteur)
RUN mkdir -p /var/www/data && chown www-data:www-data /var/www/data
COPY --chown=www-data:www-data cybershield/database.sqlite /var/www/data/database.sqlite
ENV DB_SQLITE_FILE=/var/www/data/database.sqlite

# Le dossier cybershield/ devient la racine web
COPY --chown=www-data:www-data cybershield/ /var/www/html/

COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 10000
CMD ["/usr/local/bin/start.sh"]
