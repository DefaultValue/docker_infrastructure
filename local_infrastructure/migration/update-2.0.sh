#!/bin/bash

cd ${PROJECTS_ROOT_DIR}docker_infrastructure/local_infrastructure/ || exit;
cd ${PROJECTS_ROOT_DIR}dockerizer_for_php/ || exit;

git pull origin master
cd ${PROJECTS_ROOT_DIR}docker_infrastructure/
git pull origin master

docker pull traefik:v2.2
docker pull mysql:5.6
docker pull mysql:5.7
docker pull mysql:8.0
docker pull bitnami/mariadb:10.1
docker pull bitnami/mariadb:10.2
docker pull bitnami/mariadb:10.3
docker pull bitnami/mariadb:10.4
docker pull phpmyadmin/phpmyadmin
docker pull mailhog/mailhog:v1.0.1

docker pull defaultvalue/php:5.6-development
docker pull defaultvalue/php:5.6-production
docker pull defaultvalue/php:7.0-development
docker pull defaultvalue/php:7.0-production
docker pull defaultvalue/php:7.1-development
docker pull defaultvalue/php:7.1-production
docker pull defaultvalue/php:7.2-development
docker pull defaultvalue/php:7.2-production
docker pull defaultvalue/php:7.3-development
docker pull defaultvalue/php:7.3-production
docker pull defaultvalue/php:7.4-development
docker pull defaultvalue/php:7.4-production

cd ${PROJECTS_ROOT_DIR}docker_infrastructure/local_infrastructure/
docker-compose up -d --force-recreate

echo "Please, reboot!"