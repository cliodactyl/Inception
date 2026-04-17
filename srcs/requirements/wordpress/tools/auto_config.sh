#!/bin/bash

while ! mysqladmin ping --host="$SQL_HOST" --silent; do
	sleep 1
done

if [ ! -f /var/www/wordpress/wp-load.php ]; then
	wp core download --allow-root --path=/var/www/wordpress
fi

if [ ! -f /var/www/wordpress/wp-config.php ]; then
	wp config create \
		--allow-root \
		--dbname="$SQL_DATABASE" \
		--dbuser="$SQL_USER" \
		--dbpass="$SQL_PASSWORD" \
		--dbhost="$SQL_HOST:3306" \
		--path=/var/www/wordpress
fi

if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
	wp core install \
		--allow-root \
		--url="$WP_URL" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--path=/var/www/wordpress

	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--allow-root \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--path=/var/www/wordpress
fi

exec /usr/sbin/php-fpm8.2 -F