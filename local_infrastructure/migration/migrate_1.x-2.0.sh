#!/usr/bin/env bash
sudo -k

if ! [ $(sudo id -u) = 0 ]; then
    echo "\033[31;1m"
    echo "Root password was not entered correctly!"
    exit 1;
fi

# Stop infrastructure
docker-compose down

# Create external docker network
docker network create infrastructure_network
echo "
127.0.0.1 dash.docker.local" | sudo tee -a /etc/hosts

# Start infrastructure to create volumes
docker-compose up -d --force-recreate --build

# Copy databases data vo volumes
echo "Starting data importing..."

echo "Import data for MySQL56..."
sudo docker cp mysql56_databases/. mysql56:/var/lib/mysql
echo "Import data for MySQL56 completed"

echo "Import data for MySQL57..."
sudo docker cp mysql57_databases/. mysql57:/var/lib/mysql
echo "Import data for MySQL57 completed"

echo "Import data for MariaDB101..."
sudo docker cp mariadb101_databases/data/. mariadb101:/bitnami/mariadb
echo "Import data for MariaDB101 completed"

echo "Import data for MariaDB103..."
sudo docker cp mariadb103_databases/data/. mariadb103:/bitnami/mariadb
echo "Import data for MariaDB103 completed"

echo "All imports completed"
echo "Restarting infrastructure..."

export SSL_CERTIFICATES_DIR=/misc/certs/
export PROJECTS_ROOT_DIR=/misc/apps/

docker-compose down
docker-compose up -d

printf "\033[32;1m"
read -p "/**********************
*
*    Migration Completed!
*
*    Infrastructure URLS:
*    - Docker dasboard URL - http://dash.docker.local/
*    - phpMyAdmin URL - http://phpmyadmin.docker.local/
*    (open and save the URL to bookmarks)
*
*    PRESS ANY KEY TO CONTINUE
*
\**********************
" nothing