# DEV_DOC.md

## Developer Documentation - Inception

This document explains how to set up, build, run, manage and debug the Inception project from a developer point of view.

---

## Project overview

Inception is a Docker-based infrastructure composed of three mandatory services:
1. NGINX
2. WordPress with PHP-FPM
3. MariaDB

Each service runs in its own dedicated container and is built from its own Dockerfile.

Docker Compose is used to build the images, create the network, mount the volumes and start the containers.

---

## Prerequisites

The project must be run inside a virtual machine.

Required tools:
- Docker
- Docker Compose
- Make

---

## Repository structure

.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        │   ├── conf
        │   │   └── 50-server.cnf
        │   ├── Dockerfile
        │   └── tools
        │       └── run_mariadb.sh
        ├── nginx
        │   ├── conf
        │   │   └── nginx.conf
        │   ├── Dockerfile
        │   └── tools
        │       └── wait_wordpress.sh
        └── wordpress
            ├── conf
            │   └── www.conf
            ├── Dockerfile
            └── tools
                └── auto_config.sh

---

## Environment configuration

The environment file is located at:

srcs/.env

It contains configuration values used by Docker Compose and the containers.

Example variables:

- SQL_DATABASE
- SQL_HOST
- SQL_USER
- SQL_PASSWORD
- SQL_ROOT_PASSWORD
- WP_URL
- WP_TITLE
- WP_ADMIN_USER
- WP_ADMIN_PASSWORD
- WP_ADMIN_EMAIL
- WP_USER
- WP_USER_PASSWORD
- WP_USER_EMAIL

Passwords must not be written inside Dockerfiles.

---

## Domain configuration

Add this line to /etc/hosts:

127.0.0.1    

Depending on the VM network configuration, the VM IP address may be used instead of 127.0.0.1.

---

## Build and launch

From the root of the repository, run:

make

or:

make up

This command:

- creates the required data directories
- builds the Docker images
- creates the Docker network
- creates the Docker volumes
- starts the containers

---

## Makefile commands

Start the project:

make

Start the project explicitly:

make up

Stop containers:

make stop

Start stopped containers:

make start

Stop and remove containers:

make down

Restart everything:

make restart

Show logs:

make logs

Show container status:

make ps

Remove unused Docker images and containers:

make clean

Remove containers, images, volumes and persistent data:

make fclean

Clean and rebuild:

make re

---

## Docker Compose services

### mariadb

The MariaDB service:

- builds from srcs/requirements/mariadb/Dockerfile
- uses the mariadb image name
- stores its data in /var/lib/mysql inside the container
- persists its data through the mariadb volume
- communicates with WordPress through the Docker network

Configuration files:

- srcs/requirements/mariadb/conf/50-server.cnf
- srcs/requirements/mariadb/tools/run_mariadb.sh

---

### wordpress

The WordPress service:

- builds from srcs/requirements/wordpress/Dockerfile
- uses the wordpress image name
- runs PHP-FPM
- listens internally on port 9000
- stores website files in /var/www/wordpress
- communicates with MariaDB through the Docker network

Configuration files:

- srcs/requirements/wordpress/conf/www.conf
- srcs/requirements/wordpress/tools/auto_config.sh

---

### nginx

The NGINX service:

- builds from srcs/requirements/nginx/Dockerfile
- uses the nginx image name
- is the only public entry point
- exposes port 443
- uses TLSv1.2 and TLSv1.3 only
- forwards PHP requests to WordPress through FastCGI

Configuration files:

- srcs/requirements/nginx/conf/nginx.conf
- srcs/requirements/nginx/tools/wait_wordpress.sh

---

## Docker network

The containers are connected through a Docker bridge network named inception.

This allows containers to communicate using service names:

- nginx can reach wordpress
- wordpress can reach mariadb

The project does not use:

- network: host
- links
- --link

---

## Persistent data

The persistent data is stored on the host in:

/home/user/data/mariadb
/home/user/data/wordpress

Inside the containers, these paths are mounted as:

- /var/lib/mysql for MariaDB
- /var/www/wordpress for WordPress

This allows the database and website files to persist even after containers are removed.

---

## Useful Docker commands

List containers:

docker ps

List all containers:

docker ps -a

List images:

docker images

List volumes:

docker volume ls

Inspect MariaDB volume:

docker volume inspect srcs_mariadb

Inspect WordPress volume:

docker volume inspect srcs_wordpress

List networks:

docker network ls

Inspect network:

docker network inspect srcs_inception

---

## Debugging containers

Enter the MariaDB container:

docker exec -it mariadb bash

Enter the WordPress container:

docker exec -it wordpress bash

Enter the NGINX container:

docker exec -it nginx bash

Read logs:

docker logs mariadb
docker logs wordpress
docker logs nginx

---

## MariaDB checks

Connect as root:

docker exec -it mariadb mysql -u root -p

Show databases:

SHOW DATABASES;

Select the WordPress database:

USE wordpress;

Show tables:

SHOW TABLES;

Show users:

SELECT user, host FROM mysql.user;

---

## WordPress checks

Check WordPress files:

docker exec -it wordpress ls -la /var/www/wordpress

Check WordPress installation:

docker exec -it wordpress wp core is-installed --allow-root --path=/var/www/wordpress

List WordPress users:

docker exec -it wordpress wp user list --allow-root --path=/var/www/wordpress

---

## NGINX checks

Check NGINX configuration:

docker exec -it nginx nginx -t

Check HTTPS:

curl -k https://user.42.fr

Check TLSv1.2:

openssl s_client -connect user.42.fr:443 -tls1_2

Check TLSv1.3:

openssl s_client -connect user.42.fr:443 -tls1_3

---

## Common issues

### Port 443 permission error

If the project is run with rootless Podman outside the VM, port 443 may fail with a permission error.

This is because ports below 1024 are privileged ports.

The project should be tested inside the required virtual machine with Docker.

The port mapping must remain:

443:443

---

### Website not accessible

Check:

- /etc/hosts contains user.42.fr
- containers are running
- NGINX logs
- WordPress logs
- port 443 is exposed

---

### WordPress cannot connect to database

Check:

- MariaDB container is running
- SQL_HOST is set to mariadb
- MariaDB credentials are correct
- both containers are on the same Docker network

---

### Data not reset after rebuild

Persistent data is stored in /home/user/data.

Use:

make fclean

to remove all persistent data and rebuild from scratch.

---

## Final validation checklist

Before pushing, verify:

- README.md exists at the root
- USER_DOC.md exists at the root
- DEV_DOC.md exists at the root
- Makefile exists at the root
- srcs/docker-compose.yml exists
- each service has its own Dockerfile
- NGINX exposes only port 443
- WordPress does not expose a host port
- MariaDB does not expose a host port
- TLSv1.2 and TLSv1.3 are enabled
- containers restart automatically
- no password is hardcoded in Dockerfiles
- no forbidden infinite command is used
- no latest tag is used
- network: host is not used
- links are not used
- WordPress has one administrator user and one regular user
- administrator username does not contain admin or administrator
- data is stored in /home/user/data