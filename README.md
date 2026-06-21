# 🐳 Inception : Multi-container DevOps infrastructure with Docker Compose

## 📝 Description

**Inception** is a foundational system administration and DevOps project focused on designing a secure, multi-container microservices infrastructure from scratch.

Rather than pulling pre-built images from DockerHub, this project involves writing optimized, native Dockerfiles based on Debian Bookworm to encapsulate dedicated infrastructure components:

* An **NGINX** web server backed by strict cryptographic protocols
* An isolated **WordPress** instance powered by a customized PHP-FPM pool
* A **MariaDB** relational database storage hub

The entire multi-tier ecosystem is orchestrated safely through an isolated Docker bridge network using deterministic initialization scripts, while strictly respecting modern Unix daemon architectures and PID 1 process lifecycle governance rules.

This repository demonstrates an exhaustive understanding of:

* Container isolation layers
* Network routing rules
* Persistent and non-persistent storage topologies
* Secrets protection strategies
* Infrastructure automation
* Service orchestration

---

# 🏗️ Infrastructure architecture

All traffic flows through a single, strictly controlled ingress point:

```text
           Client (Browser)
                  │
                  ▼  [ HTTPS :443 ]
      ┌─────────────────────────┐
      │        NGINX            │
      │ TLS v1.2 / TLS v1.3     │
      └─────────────────────────┘
                  │
                  ▼  [ FastCGI :9000 ]
      ┌─────────────────────────┐
      │      WordPress          │
      │       PHP-FPM           │
      └─────────────────────────┘
                  │
                  ▼  [ MySQL :3306 ]
      ┌─────────────────────────┐
      │       MariaDB           │
      │   persistent storage    │
      └─────────────────────────┘
```

---

# 🔒 Architectural highlights and constraints

## PID 1 daemon rules

Containers run natively without anti-patterns such as:

```bash
tail -f
sleep infinity
```

Services remain alive because their entrypoint scripts launch foreground processes correctly:

```bash
nginx -g "daemon off;"
php-fpm8.2 -F
mysqld_safe
```

This respects Docker's process model and allows clean signal propagation and container shutdown.

---

## Encapsulated network isolation

Host port mapping is allowed only for NGINX (`443`).

WordPress and MariaDB communicate exclusively through the internal Docker bridge network using automatic Docker DNS resolution.

Benefits include:

* Reduced attack surface
* Clear service boundaries
* No direct database exposure
* Simplified service discovery

---

## Automatic crash recovery

All services enforce an automatic recovery policy through:

```yaml
restart: always
```

This ensures containers are restarted automatically after unexpected failures.

---

# 📁 Repository layout

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        │   ├── conf/
        │   │   └── 50-server.cnf
        │   ├── Dockerfile
        │   └── tools/
        │       └── run_mariadb.sh
        │
        ├── nginx/
        │   ├── conf/
        │   │   └── nginx.conf
        │   ├── Dockerfile
        │   └── tools/
        │       └── wait_wordpress.sh
        │
        └── wordpress/
            ├── conf/
            │   └── www.conf
            ├── Dockerfile
            └── tools/
                └── auto_config.sh
```

---

# ⚙️ Core technical comparative analysis

## 1. Virtual machines vs Docker containers

### Virtual machines

Virtual machines virtualize physical hardware.

Each VM runs:

* Its own operating system
* Its own kernel
* Independent memory allocation
* Independent storage management

This provides strong isolation but introduces significant resource overhead.

### Docker containers

Containers virtualize at the operating system layer.

They share the host Linux kernel while maintaining isolation through:

* Namespaces
* cgroups
* Filesystem layers

Benefits include:

* Near-native performance
* Reduced memory usage
* Faster startup times
* Smaller storage footprint

---

## 2. Secrets management vs environment variables

> ⚠️ Security note
>
> A `.env` file should be treated as a deployment configuration layer.
>
> Hardcoding passwords or committing `.env` files to version control exposes credentials to potential leaks.

### Environment variables

Suitable for:

* Domain names
* Application settings
* Feature flags
* Non-sensitive configuration values

### Docker secrets

Production-grade secret management relies on Docker secrets.

Sensitive data can be injected through:

```text
/run/secrets/
```

instead of environment variables.

Advantages:

* Reduced accidental exposure
* Better separation of concerns
* No leakage through `env`
* Cleaner secret rotation workflows

---

## 3. Docker bridge network vs host networking

### Host networking

```yaml
network_mode: host
```

Removes network isolation entirely.

Containers directly share the host network stack.

Drawbacks:

* Larger attack surface
* Port conflicts
* Reduced isolation

### Docker bridge networking

Creates an isolated virtual network.

Benefits:

* Internal DNS resolution
* Service discovery by container name
* Reduced exposure
* Better security boundaries

---

## 4. Docker volumes vs bind mounts

### Bind mounts

Bind mounts map a host directory directly into a container.

Advantages:

* Convenient for development
* Immediate file synchronization

Drawbacks:

* Host dependency
* Permission inconsistencies
* Reduced portability

### Docker volumes

Managed directly by Docker.

Advantages:

* Better isolation
* Persistence across container rebuilds
* Improved portability
* Cleaner lifecycle management

---

# 🚀 Instructions and quick start

## 📋 System prerequisites

Ensure your environment provides:

* Linux or a Linux virtual machine
* Docker Engine
* Docker Compose
* GNU Make

---

## ⚙️ Environment provisioning

Add the local domain entry:

```bash
echo "127.0.0.1 user.42.fr" | sudo tee -a /etc/hosts
```

Build and start the infrastructure:

```bash
make
```

This command:

* Creates persistent volumes
* Builds every Docker image
* Creates the bridge network
* Starts all services

---

# 🛠️ Operations matrix

| Command            | Description                                     |
| ------------------ | ----------------------------------------------- |
| `make` / `make up` | Build images, create volumes and start services |
| `make stop`        | Stop running containers                         |
| `make down`        | Remove containers and networks                  |
| `make ps`          | Display service status                          |
| `make clean`       | Remove unused containers and dangling images    |
| `make fclean`      | Complete purge including persistent volumes     |
| `make re`          | Rebuild the infrastructure from scratch         |

---

# 🌐 Verification, testing and debugging

## Verify TLS enforcement

```bash
openssl s_client -connect user.42.fr:443 -tls1_2
openssl s_client -connect user.42.fr:443 -tls1_3
```

---

## Check database integrity

```bash
docker exec -it mariadb \
mysql -u root -p"${SQL_ROOT_PASSWORD}" \
-e "SHOW DATABASES; USE wordpress; SHOW TABLES;"
```

---

## Verify WordPress users

```bash
docker exec -it wordpress \
wp user list \
--allow-root \
--path=/var/www/wordpress
```

---

# 📚 Resources and AI use disclosure

## 📖 References and standards

### Docker system engineering

Official Docker documentation covering:

* Container security
* Layer caching
* Multi-stage builds
* Networking
* Persistent storage

### NGINX architecture

Reference material for:

* TLS v1.2
* TLS v1.3
* Reverse proxy design
* Upstream configuration

---

## 🤖 Generative AI framework integration

### Boilerplate optimization

AI assistance was used to improve dependency validation logic in scripts such as `wait_wordpress.sh`, reducing startup race conditions between NGINX and WordPress.

### DevOps best-practice review

Generative tools were used to review:

* Dockerfile instruction ordering
* Layer optimization strategies
* Package installation workflows
* Build cache efficiency

### Validation checkpoints

All AI-assisted suggestions were manually reviewed, tested and validated to ensure:

* No hardcoded credentials
* Stable startup sequences
* Predictable shutdown behavior
* Correct service orchestration
* Reproducible deployments

---

# 🎯 Objectives

This project explores:

* Docker fundamentals
* Docker Compose orchestration
* Linux system administration
* Service isolation
* Container networking
* TLS configuration
* NGINX administration
* MariaDB deployment
* WordPress automation
* Persistent storage management
* Secrets handling
* Infrastructure as code principles
* Production-grade deployment workflows
