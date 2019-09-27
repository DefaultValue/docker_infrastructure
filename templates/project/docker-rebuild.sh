#!/usr/bin/env bash
docker-compose -f ./docker-compose.yml -f ./docker-compose-dev.yml down
#docker-compose -f ./docker-compose.yml -f ./docker-compose-dev.yml kill
#docker rm $(docker ps -a -q) # remove all stopped
docker-compose -f ./docker-compose.yml -f ./docker-compose-dev.yml rm -f
docker image prune -af # --all --force
docker volume prune -f
#docker-compose up -d
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d --build --force-recreate
# docker-compose -f ./docker-compose.yml -f ./docker-compose-dev.yml up -d
# docker-sync-stack start