#!/bin/bash

docker network create infrastructure_network

cd ${PROJECTS_ROOT_DIR}docker_infrastructure/local_infrastructure/ || exit
docker-compose up -d --force-recreate