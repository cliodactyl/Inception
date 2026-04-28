#!/bin/bash

if [ ! -d /run/mysqld ]; then
	mkdir -p /run/mysqld
fi

chown mysql:mysql /run/mysqld
chmod 755 /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --skip-networking=0 --user=mysql --datadir=/var/lib/mysql &
pid="$!"

timeout=30
while ! mysqladmin ping --silent; do
	sleep 1
	timeout=$((timeout - 1))
	if [ "$timeout" -le 0 ]; then
		echo "MariaDB failed to start."
		exit 1
	fi
done

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
wait "$pid"

exec mysqld_safe --skip-networking=0 --user=mysql --datadir=/var/lib/mysql