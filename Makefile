ifneq (,$(wildcard ./.env))
    include .env
    export
endif

service = server

up:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

down:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

deploy:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml config | docker stack deploy -c - ${STACK}

deploy-ssl:
	 docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.ssl.yml config | docker stack deploy -c - ${STACK}

stop:
	docker stack rm ${STACK}

log:
	docker service logs -f ${STACK}_$(service)
