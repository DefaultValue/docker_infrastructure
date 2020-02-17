#!/usr/bin/env bash
# >>> Turn off composition, remove containers
docker-compose -f docker-compose.yml -f docker-compose-prod.yml down
# >>> Remove ALL stopped containers
# docker rm $(docker ps -a -q)
# >>> Remove all images
# docker image prune -af # --all --force
# >>> Remove all volumes
# docker volume prune -f
# >>> Run the composition
docker-compose -f docker-compose.yml -f docker-compose-prod.yml up -d --force-recreate --build
# docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d --force-recreate --build
# >>> Run the composition in the production mode (without debug and under the root user)
# docker-compose -f docker-compose.yml  up -d --build --force-recreate
# >>> For MacOS users: start docker-sync-stack
# docker-sync-stack start