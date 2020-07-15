#!/usr/bin/env bash
# >>> Turn off composition, remove containers
docker-compose -f docker-compose.yml down
# >>> Remove ALL stopped containers
# docker rm $(docker ps -a -q)
# >>> Clean Docker images cache
# docker image prune -af # --all --force
# >>> Remove all volumes
# docker volume prune -f
# >>> Run the composition
docker-compose -f docker-compose.yml up -d --force-recreate --build
# >>> Run composition with multiple docker-compose configuration files if needed
# docker-compose -f docker-compose.yml -f docker-compose-override.yml up -d --force-recreate --build
# >>> For MacOS users: start docker-sync-stack
# docker-sync-stack start