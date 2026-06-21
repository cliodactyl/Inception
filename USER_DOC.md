# USER_DOC.md

## User Documentation - Inception

This document explains how to use the Inception project as an end user or administrator.

---

## Provided services

This stack provides three services:
1. NGINX: HTTPS web server and only public entry point.
2. WordPress: website application running with PHP-FPM.
3. MariaDB: database used by WordPress.

The website is accessible through HTTPS only.

---

## Start the project

From the root of the repository, run:

make

This command builds the images and starts all containers.

---

## Stop the project

To stop the containers without deleting data:

make stop

To stop and remove the containers:

make down

---

## Restart the project

make restart

---

## Access the website

Before opening the website, make sure this line exists in /etc/hosts:

127.0.0.1    cldalmaz.42.fr

Then open:

https://cldalmaz.42.fr

A browser warning may appear because the certificate is self-signed.  
This is normal for this local project.

---

## Access the WordPress administration panel

Open:

https://cldalmaz.42.fr/wp-admin

The administrator credentials are defined in the environment configuration file.

---

## Locate credentials

Credentials are stored in the project environment file:

srcs/.env

This file contains values such as:

- MariaDB database name
- MariaDB user
- MariaDB password
- WordPress administrator user
- WordPress administrator password
- WordPress regular user

Credentials must not be hardcoded inside Dockerfiles.

---

## Check that services are running

Use:

make ps

Or:

docker ps

You should see three running containers:
1. nginx
2. wordpress
3. mariadb

---

## Check logs

Use:

make logs

This displays logs from all containers.

To check one container only:

docker logs nginx
docker logs wordpress
docker logs mariadb

---

## Check the website from the terminal

Use:

curl -k https://cldalmaz.42.fr

The -k option is used because the certificate is self-signed.

---

## Check TLS

To check TLSv1.2:

openssl s_client -connect cldalmaz.42.fr:443 -tls1_2

To check TLSv1.3:

openssl s_client -connect cldalmaz.42.fr:443 -tls1_3

---

## Persistent data

The project stores persistent data in:

/home/cldalmaz/data/mariadb
/home/cldalmaz/data/wordpress

MariaDB data is stored in the first directory.  
WordPress website files are stored in the second directory.

This means the data can survive container removal and rebuilds.

---

## Full cleanup

To remove containers, images, volumes and persistent data:

make fclean

Warning: this deletes the database and WordPress files.

---

## Rebuild from scratch

To fully clean and rebuild the project:

make re