*This project has been created as part of the 42 curriculum by cldalmaz.*

# Inception

## 🧠 Description

This project aims to set up a small infrastructure using Docker.

It consists of three services running in separate containers:

1. NGINX (web server with HTTPS)  
2. WordPress (PHP-FPM)  
3. MariaDB (database)  

All services are built from scratch using Dockerfiles and are orchestrated with Docker Compose.

---

## 🏗️ Architecture

Client (browser)  
        ↓  
     NGINX (443 / HTTPS)  
        ↓  
 WordPress (PHP-FPM)  
        ↓  
     MariaDB  

- NGINX: handles HTTPS requests (TLSv1.2 / TLSv1.3)  
- WordPress: communicates with MariaDB  
- Each service runs in its own container  
- All containers are connected via a Docker network  

---

## 📁 Project structure

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

## ⚙️ Setup

Add the following line to your /etc/hosts:

127.0.0.1    <your_login>.42.fr  

Example:

127.0.0.1    cldalmaz.42.fr  

---

## 🚀 Instructions

### Start the infrastructure

make  

Builds and starts all containers using Docker Compose.

---

### Remove containers (without deleting data)

make down  

---

### Show running containers

make ps  

---

### Rebuild from scratch (⚠️ deletes containers and images)

make re  

---

### Full clean (⚠️ deletes EVERYTHING including volumes and data)

make fclean  

---

## 🌐 Access

Open in your browser:

https://<your_login>.42.fr  

⚠️ A self-signed certificate warning may appear.  
Accept the risk to access the website.

---

## 💾 Volumes

Data is persisted in:

/home/<your_login>/data/mariadb  
/home/<your_login>/data/wordpress  

These volumes ensure that the database and WordPress files are preserved even if containers are removed or rebuilt.

---

## 🔐 Environment variables

All sensitive data is stored in the .env file.

No credentials are hardcoded inside Dockerfiles, in accordance with project requirements.

---

## 🔍 Debugging & Useful Commands

# List running containers  
docker ps  

# Access containers  
docker exec -it wordpress bash  
docker exec -it mariadb bash  

# Connect to MariaDB  
docker exec -it mariadb mysql -u root -p  

# Check volumes  
docker volume ls  
docker volume inspect srcs_wordpress  
docker volume inspect srcs_mariadb  

# Check network  
docker network ls  
docker network inspect srcs_inception  

# Test HTTPS  
curl -k https://<your_login>.42.fr  

# Check TLS  
openssl s_client -connect <your_login>.42.fr:443 -tls1_2  
openssl s_client -connect <your_login>.42.fr:443 -tls1_3  

# Check non-empty database
SELECT * FROM wp_users;

---

## ⚖️ Design Choices

### Virtual Machines vs Docker

A virtual machine emulates an entire operating system with its own kernel.  
Docker containers share the host kernel and isolate only the application and its dependencies.

Docker is lighter, faster to start, and well-suited for microservice architectures like this project.

---

### Secrets vs Environment Variables

Environment variables are used to configure services (database name, host, etc.).

Sensitive data (passwords) should not be hardcoded in Dockerfiles.  
Using a .env file improves security and flexibility.

---

### Docker Network vs Host Network

A Docker bridge network allows containers to communicate securely using service names.

Only NGINX is exposed to the host, which improves security and follows the subject rules.

The use of network: host, links, or --link is forbidden.

---

### Docker Volumes vs Bind Mounts

Docker volumes are used to persist data independently of containers.

In this project, volumes store:
1. MariaDB database files  
2. WordPress website files  

They ensure data persistence even after container removal.

---

## 📚 Resources

During this project, the following resources were used:

- Docker official documentation  
- Docker Compose documentation  
- NGINX documentation  
- MariaDB documentation  
- WordPress documentation  
- Stack Overflow for debugging specific issues  
- Various technical articles and tutorials about Docker and system administration  

AI was used as a learning assistant to better understand:
- Docker architecture  
- Container communication  
- Volumes and networks  
- Debugging strategies  

All generated content was reviewed, tested, and fully understood before being used.

---

## 🧪 Notes

- Containers restart automatically 
- No container runs with infinite loops  
- NGINX is the only entry point (port 443)  
- TLSv1.2 and TLSv1.3 are enabled  
- No use of forbidden Docker features (host network, links, etc.)  
- Each service runs in its own container  
- All images are built from custom Dockerfiles  