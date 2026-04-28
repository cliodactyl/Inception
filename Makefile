NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml

all: up

up:
	mkdir -p $(HOME)/data/mariadb
	mkdir -p $(HOME)/data/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean: down
	docker system prune -af

fclean: down
	docker system prune -af --volumes
	docker run --rm -v $(HOME)/data:/data debian:oldstable sh -c "rm -rf /data/mariadb /data/wordpress"

re: fclean all

.PHONY: all up down start stop restart logs ps clean fclean re