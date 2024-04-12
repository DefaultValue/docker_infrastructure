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

docker login -u defaultvalue

docker push defaultvalue/php:5.6.40-production
docker push defaultvalue/php:5.6.40-development

docker push defaultvalue/php:7.0.33-production
docker push defaultvalue/php:7.0.33-development

docker push defaultvalue/php:7.1.33-production
docker push defaultvalue/php:7.1.33-development

docker push defaultvalue/php:7.2.34-production
docker push defaultvalue/php:7.2.34-development

docker push defaultvalue/php:7.3.33-production
docker push defaultvalue/php:7.3.33-development

docker push defaultvalue/php:7.4.33-production
docker push defaultvalue/php:7.4.33-development

docker push defaultvalue/php:8.0.30-production
docker push defaultvalue/php:8.0.30-development

docker push defaultvalue/php:8.1.27-production
docker push defaultvalue/php:8.1.27-development

docker push defaultvalue/php:8.2.18-production
docker push defaultvalue/php:8.2.18-development

docker push defaultvalue/php:8.3.6-production
docker push defaultvalue/php:8.3.6-development