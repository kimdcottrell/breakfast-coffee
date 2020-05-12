#!make
sinclude .env

.PHONY: help

.DEFAULT_GOAL := help

shell: ## Django: Start a shell as root
	docker-compose exec project bash

build: ## Docker: Build or rebuild services
	docker-compose build

up: ## Docker: Builds (or fetch from cache), (re)creates, starts, and attaches to containers for a service.
	docker-compose up -d

down: ## Docker: Stop and remove containers, networks, images, and volumes
	docker-compose down -v --remove-orphans

start: ## Docker: Start services
	docker-compose start

pause: ## Docker: Stop services
	docker-compose stop

restart: down build up ## Docker: make down, make build, and make up

destroy: down ## Docker: remove everything regarding this project, as well as all orphaned containers and networks
	docker system prune -af --volumes

status: ## Docker: Status of all containers and networks
	docker ps -a
	docker network ls

logs: ## Docker: Tail the project logs
	docker-compose logs -tf --tail="50"

coffee: ## Make: Get your terminal caffeinated
	@echo $$'\342\230\225\012'

# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Make: Helper Team 6 comin' in hot
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)