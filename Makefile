.PHONY: build up down over test db_init db_migrate db_upgrade local_flask local_react local local_build local_clean local_build_flask local_clean_flask local_build_react local_clean_react sb help

FLASK_ENV ?= development

help:
	@echo "Override 'FLASK_ENV' to change environment, e.g.: make up FLASK_ENV=testing"
	@echo " "
	@echo "up          			- Docker Compose 	- Start services."
	@echo "build       			- Docker Compose 	- Build images."
	@echo "down        			- Docker Compose 	- Stop services."
	@echo "over        			- Docker Compose 	- Rebuild and restart services."
	@echo " "
	@echo "pytest        		- PyTest 			- Run tests on Flask."
	@echo "sqlite_connect		- SQLite 			- Connect to SQLite if it's running."
	@echo "sb				 	- Storybook    		- Run Storybook."
	@echo " "
	@echo "db_init     			- SQLAlchemy 		- Initialize database."
	@echo "db_migrate  			- SQLAlchemy 		- Migrate database."
	@echo "db_upgrade  			- SQLAlchemy 		- Upgrade database."
	@echo " "
	@echo "local       			- Flask+React 		- Run Flask and React locally."
	@echo "local_build 			- Flask+React 		- Set up local development environment."
	@echo "local_clean 			- Flask+React 		- Clean up local development environment."
	@echo " "
	@echo "local_flask 			- Flask 			- Run Flask locally."
	@echo "local_build_flask 	- Flask      		- Set up local Flask development environment."
	@echo "local_clean_flask 	- Flask      		- Clean up local Flask development environment."
	@echo " "
	@echo "local_react 			- React			 	- Run React locally."
	@echo "local_build_react 	- React      		- Set up local React development environment."
	@echo "local_clean_react 	- React      		- Clean up local React development environment."

up:
	FLASK_ENV=$(FLASK_ENV) docker compose up

build:
	docker compose build

down:
	docker compose down

over: down build up

pytest:
	docker compose run api pytest

sqlite_connect:
	@dbfile=$$(ls api/*.db 2>/dev/null | head -n 1); \
	if [ "$$dbfile" ]; then \
		sqlite3 "$$dbfile"; \
	else \
		echo "No SQLite DB found in the 'api' directory."; \
	fi

sb:
	cd ui; \
	npm run storybook &

db_init:
	docker compose run api flask db init

db_migrate:
	docker compose run api flask db migrate

db_upgrade:
	docker compose run api flask db upgrade

kill_ports:
	@for port in 5174 5000; do \
		pid=$$(lsof -ti :$$port); \
		if [ ! -z "$$pid" ]; then \
			kill -9 $$pid; \
		fi \
	done;

local: kill_ports
	@echo "Starting Flask and React locally..."
	@. api/venv/bin/activate && \
	cd api && flask run & \
	FLASK_PID=$$!; \
	cd ui && npm run dev & \
	REACT_PID=$$!; \
	trap 'echo "Cleaning up processes..."; if ps -p $$FLASK_PID > /dev/null; then kill $$FLASK_PID; fi; if ps -p $$REACT_PID > /dev/null; then kill $$REACT_PID; fi' INT; \
	wait;

local_build: local_build_flask local_build_react

local_clean: local_clean_flask local_clean_react

local_flask:
	@echo "Starting local Flask..."
	@. api/venv/bin/activate; \
	cd api; \
	flask run &

local_react:
	@echo "Starting local React..."
	@cd ui; npm run dev &

local_build_flask:
	cd api; \
	python3 -m venv venv; \
	. venv/bin/activate; \
	pip install --upgrade pip; \
	pip install -r requirements.txt

local_clean_flask:
	rm -rf api/venv

local_build_react:
	cd ui; \
	npm install; \
	npm update

local_clean_react:
	rm -rf ui/node_modules
