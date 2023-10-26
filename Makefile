ifneq (,$(wildcard ./.env))
   include .env
   export
   ENV_FILE_PARAM = --env-file .env
endif

RED ?= \033[0;31m
GREEN ?= \033[0;32m
YELLOW ?= \033[0;33m
BLUE ?= \033[0;34m
PURPLE ?= \033[0;35m


help:
	@echo -e "\n$(WHITE)Available commands:$(COFF)"
	@echo -e "$(BLUE)make build$(COFF)                            - Builds or rebuilds services"
	@echo -e "$(BLUE)make build-dev$(COFF)                        - Builds or rebuilds development services"
	@echo -e "$(BLUE)make build-with-no-cache$(COFF)              - Builds or rebuilds services with no cache"
	@echo -e "$(BLUE)make build-with-no-cache-dev$(COFF)          - Builds or rebuilds services with no cache in development"
	@echo -e "$(GREEN)make start-services$(COFF)                  - Starts Django service"
	@echo -e "$(GREEN)make start-services-dev$(COFF)              - Starts Django dev service"
	@echo -e "$(GREEN)make start-services-detached$(COFF)         - Starts Django service in the background"
	@echo -e "$(GREEN)make start-services-detached-dev$(COFF)     - Starts Django dev service in the background"
	@echo -e "$(PURPLE)make shell$(COFF)                          - Starts a Linux shell (bash) in the django container"
	@echo -e "$(PURPLE)make shell-dev$(COFF)                      - Starts a Linux shell (bash) in the django dev container"
	@echo -e "$(PURPLE)make django-shell$(COFF)                   - Starts a django python shell in the django container"
	@echo -e "$(PURPLE)make django-shell-dev$(COFF)               - Starts a django python shell in the django dev container"
	@echo -e "$(RED)make stop-services$(COFF)                     - Stops Django service"
	@echo -e "$(RED)make stop-services-dev$(COFF)                 - Stops Django dev service"
	@echo -e "$(RED)make stop-delete-volumes$(COFF)               - Deletes volumes associated with Django service"
	@echo -e "$(RED)make stop-delete-volumes-dev$(COFF)           - Deletes volumes associated with Django dev service"
	@echo -e "$(BLUE)make makemigrations$(COFF)                   - Runs Django's migrate command in the container"
	@echo -e "$(BLUE)make makemigrations-dev$(COFF)               - Runs Django's migrate command in the dev container"
	@echo -e "$(BLUE)make migrate$(COFF)                          - Runs Django's makemigrations command in the container"
	@echo -e "$(BLUE)make migrate-dev$(COFF)                      - Runs Django's makemigrations command in the dev container"
	@echo -e "$(BLUE)make create-superuser$(COFF)                 - Runs Django's createsuperuser command in the container"
	@echo -e "$(BLUE)make create-superuser-dev$(COFF)             - Runs Django's createsuperuser command in the dev container"
	@echo -e "$(YELLOW)make print-logs$(COFF)                     - Prints logs on the shell"
	@echo -e "$(YELLOW)make print-logs-dev$(COFF)                 - Prints logs on the shell in development"
	@echo -e "$(YELLOW)make print-logs-interactive$(COFF)         - Prints interactive logs on the shell"
	@echo -e "$(YELLOW)make print-logs-interactive-dev$(COFF)     - Prints interactive logs on the dev shell"

build:
	@echo -e "$(BLUE)Building images:$(COFF)"
	@docker compose -f docker-compose-prod.yml build

build-dev:
	@echo -e "$(BLUE)Building development images:$(COFF)"
	@docker compose -f docker-compose-dev.yml build

build-with-no-cache:
	@echo -e "$(BLUE)Building images with no cache:$(COFF)"
	@docker compose build --no-cache

build-with-no-cache-dev:
	@echo -e "$(BLUE)Building development images with no cache:$(COFF)"
	@docker compose -f docker-compose-dev.yml build --no-cache

start-services:
	@echo -e "$(GREEN)Starting Django backend service:$(COFF)"
	@docker compose up

start-services-dev:
	@echo -e "$(GREEN)Starting Django development backend service:$(COFF)"
	@docker compose -f docker-compose-dev.yml up

start-services-detached:
	@echo -e "$(GREEN)Starting Django backend service in the background:$(COFF)"
	@docker compose up -d

start-services-detached-dev:
	@echo -e "$(GREEN)Starting Django development backend service in the background:$(COFF)"
	@docker compose -f docker-compose-dev.yml up -d

shell:
	@echo -e "$(PURPLE)Starting Linux (Bash) shell in Django:$(COFF)"
	@docker compose run --rm django bash

shell-dev:
	@echo -e "$(PURPLE)Starting Linux (Bash) shell in Django development:$(COFF)"
	@docker compose -f docker-compose-dev.yml run --rm django bash

django-shell:
	@echo -e "$(PURPLE)Starting Django-Python shell:$(COFF)"
	@docker compose run --rm django ./manage.py shell

django-shell-dev:
	@echo -e "$(PURPLE)Starting Django-Python shell in development:$(COFF)"
	@docker compose -f docker-compose-dev.yml run --rm django ./manage.py shell

stop-services:
	@echo -e "$(RED)Stopping Django backend service:$(COFF)"
	@docker compose down

stop-services-dev:
	@echo -e "$(RED)Stopping Django development backend service:$(COFF)"
	@docker compose -f docker-compose-dev.yml down

stop-delete-volumes:
	@echo -e "$(RED)Deleting volumes for Django and PostGIS:$(COFF)"
	@docker compose down --volumes

stop-delete-volumes-dev:
	@echo -e "$(RED)Deleting volumes for all services in development:$(COFF)"
	@docker compose -f docker-compose-dev.yml down --volumes

makemigrations:
	@echo -e "$(BLUE)Make Django migrations:$(COFF)"
	@docker compose run --rm django ./manage.py makemigrations $(cmd)

makemigrations-dev:
	@echo -e "$(BLUE)Make Django migrations in development:$(COFF)"
	@docker compose -f docker-compose-dev.yml run --rm django ./manage.py makemigrations $(cmd)

migrate:
	@echo -e "$(BLUE)Update database schema from Django migrations:$(COFF)"
	@docker compose run --rm django ./manage.py migrate $(cmd)

migrate-dev:
	@echo -e "$(BLUE)Update database schema from Django migrations in development:$(COFF)"
	@docker compose -f docker-compose-dev.yml run --rm django ./manage.py migrate $(cmd)

create-superuser:
	@echo -e "$(BLUE)Create superuser for the backend admin:$(COFF)"
	@docker compose run --rm django ./manage.py createsuperuser $(cmd)

create-superuser-dev:
	@echo -e "$(BLUE)Create superuser for the backend admin in development:$(COFF)"
	@docker compose -f docker-compose-dev.yml run --rm django ./manage.py createsuperuser $(cmd)

print-logs:
	@echo -e "$(YELLOW)Print out logs:$(COFF)"
	@docker compose logs django$(cmd)

print-logs-dev:
	@echo -e "$(YELLOW)Print out logs in development:$(COFF)"
	@docker compose -f docker-compose-dev.yml logs django$(cmd)

print-logs-interactive:
	@echo -e "$(YELLO)Print out logs:$(COFF)"
	@docker compose logs --follow django $(cmd)

print-logs-interactive-dev:
	@echo -e "$(YELLO)Print out logs in development:$(COFF)"
	@docker compose -f docker-compose-dev.yml logs --follow django $(cmd)
