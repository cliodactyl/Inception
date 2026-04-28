# Inception

## 🧠 Description

This project aims to set up a small infrastructure using Docker.

It consists of three services running in separate containers:

* NGINX (web server with HTTPS)
* WordPress (PHP-FPM)
* MariaDB (database)

All services are built from scratch using Dockerfiles and are orchestrated with Docker Compose.

---

## 🏗️ Architecture

```
Client (browser)
        ↓
     NGINX (443 / HTTPS)
        ↓
 WordPress (PHP-FPM)
        ↓
     MariaDB
```

* NGINX handles HTTPS (TLSv1.2 / TLSv1.3)
* WordPress communicates with MariaDB
* Each service runs in its own container
* All containers are connected via a Docker network

---

## 📁 Project structure

```
.
├── Makefile
├── README.md
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        │   ├── conf
        │   │   └── 50-server.cnf
        │   ├── Dockerfile
        │   └── tools
        │       └── run_mariadb.sh
        ├── nginx
        │   ├── conf
        │   │   └── nginx.conf
        │   ├── Dockerfile
        │   └── tools
        │       └── wait_wordpress.sh
        └── wordpress
            ├── conf
            │   └── www.conf
            ├── Dockerfile
            └── tools
                └── auto_config.sh

---

## ⚙️ Setup

Add the following line to your `/etc/hosts`:

```
127.0.0.1    <your_login>.42.fr
```

Example:

```
127.0.0.1    cldalmaz.42.fr
```

---

## 🚀 Usage

### Build and start all services

```
make
```

### Stop services

```
make down
```

### Restart everything

```
make re
```

### View logs

```
make logs
```

---

## 💾 Volumes

Data is persisted in:

```
~/data/mariadb
~/data/wordpress
```

---

## 🔐 Environment variables

All sensitive data is stored in the `.env` file.

---

## 🐳 Useful Docker commands

```
docker ps
docker images
docker stop <container>
docker rm <container>
docker system prune -af
```

---

## 🧪 Notes

* Containers restart automatically (`restart: always`)
* No container runs with infinite loops
* NGINX is the only entry point (port 443)
* TLSv1.2 and TLSv1.3 are enabled
