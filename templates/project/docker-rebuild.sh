#!/usr/bin/env bash
docker-compose -f ./docker-compose.yml -f ./docker-compose-dev.yml down
docker rm $(docker ps -a -q) # remove all stopped
# docker image prune -af # --all --force
# docker volume prune -f
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d --force-recreate --build
# docker-compose -f docker-compose.yml  up -d --build --force-recreate
# docker-sync-stack start