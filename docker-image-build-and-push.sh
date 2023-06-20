#!/bin/bash
# 1. Build development and production images
# 2. Run `DOCKERIZER magento:test dockerfiles`
# 3. Push images

# Check extensions list and custom PHP configuration file
# docker exec -it $(DOCKERIZER composition:get-container-name php) php -v
# docker exec -it $(DOCKERIZER composition:get-container-name php) php -r 'var_export(get_loaded_extensions());'
# docker exec -it $(DOCKERIZER composition:get-container-name php) php -r 'var_export(get_loaded_extensions(true));'
# docker exec -it $(DOCKERIZER composition:get-container-name php) cat /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

set -e

docker login -u defaultvalue -p

docker container prune -f
docker image prune -af

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/5.6/ || exit
docker build -t defaultvalue/php:5.6-production . -f production.Dockerfile
docker push defaultvalue/php:5.6-production
docker build -t defaultvalue/php:5.6-development . -f development.Dockerfile
docker push defaultvalue/php:5.6-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/7.0/ || exit
docker build -t defaultvalue/php:7.0-production . -f production.Dockerfile
docker push defaultvalue/php:7.0-production
docker build -t defaultvalue/php:7.0-development . -f development.Dockerfile
docker push defaultvalue/php:7.0-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/7.1/ || exit
docker build -t defaultvalue/php:7.1-production . -f production.Dockerfile
docker push defaultvalue/php:7.1-production
docker build -t defaultvalue/php:7.1-development . -f development.Dockerfile
docker push defaultvalue/php:7.1-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/7.2/ || exit
docker build -t defaultvalue/php:7.2-production . -f production.Dockerfile
docker push defaultvalue/php:7.2-production
docker build -t defaultvalue/php:7.2-development . -f development.Dockerfile
docker push defaultvalue/php:7.2-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/7.3/ || exit
docker build -t defaultvalue/php:7.3-production . -f production.Dockerfile
docker push defaultvalue/php:7.3-production
docker build -t defaultvalue/php:7.3-development . -f development.Dockerfile
docker push defaultvalue/php:7.3-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/7.4/ || exit
docker build -t defaultvalue/php:7.4-production . -f production.Dockerfile
docker push defaultvalue/php:7.4-production
docker build -t defaultvalue/php:7.4-development . -f development.Dockerfile
docker push defaultvalue/php:7.4-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/8.0/ || exit
docker build -t defaultvalue/php:8.0-production . -f production.Dockerfile
docker push defaultvalue/php:8.0-production
docker build -t defaultvalue/php:8.0-development . -f development.Dockerfile
docker push defaultvalue/php:8.0-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/8.1/ || exit
docker build -t defaultvalue/php:8.1-production . -f production.Dockerfile
docker push defaultvalue/php:8.1-production
docker build -t defaultvalue/php:8.1-development . -f development.Dockerfile
docker push defaultvalue/php:8.1-development

cd /home/maksymz/misc/apps/docker_infrastructure/templates/php/8.2/ || exit
docker build -t defaultvalue/php:8.2-production . -f production.Dockerfile
docker push defaultvalue/php:8.2-production
docker build -t defaultvalue/php:8.2-development . -f development.Dockerfile
docker push defaultvalue/php:8.2-development