NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml

DATA_DIR = $(HOME)/data
MARIADB_DIR = $(DATA_DIR)/mariadb
WORDPRESS_DIR = $(DATA_DIR)/wordpress

all: up

up:
	@mkdir -p $(MARIADB_DIR)
	@mkdir -p $(WORDPRESS_DIR)
	@$(COMPOSE) up -d --build

down:
	@$(COMPOSE) down

start:
	@$(COMPOSE) start

stop:
	@$(COMPOSE) stop

restart: down up

logs:
	@$(COMPOSE) logs -f

ps:
	@$(COMPOSE) ps

clean: down
	@docker system prune -af

fclean: down
	@docker system prune -af --volumes
	@docker run --rm -v $(DATA_DIR):/data debian:bookworm sh -c "rm -rf /data/mariadb /data/wordpress"

re: fclean all

.PHONY: all up down start stop restart logs ps clean fclean re