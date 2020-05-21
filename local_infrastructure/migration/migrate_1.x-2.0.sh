#!/usr/bin/env bash
###
# Migration script for Ubuntu 18.04 where all files were located in the "/misc/apps/" folder
# Change paths for "PROJECTS_ROOT_DIR" and "SSL_CERTIFICATES_DIR" if your files are located elsewhere
###
sudo -k

if ! [ $(sudo id -u) = 0 ]; then
    echo "\033[31;1m"
    echo "Root password was not entered correctly!"
    exit 1;
fi

export PROJECTS_ROOT_DIR=/misc/apps/
export SSL_CERTIFICATES_DIR=/misc/share/ssl/
export EXECUTION_ENVIRONMENT=development

echo "
export PROJECTS_ROOT_DIR=/misc/apps/
export SSL_CERTIFICATES_DIR=/misc/share/ssl/
export EXECUTION_ENVIRONMENT=development" >> ~/.bash_aliases

cd ${PROJECTS_ROOT_DIR}dockerizer_for_php/ || exit
git config core.fileMode false
git reset --hard HEAD
git pull origin master
rm -rf vendor/*
composer install

cd ${PROJECTS_ROOT_DIR}docker_infrastructure/local_infrastructure/ || exit
# Stop infrastructure
docker-compose down
cd ..
git config core.fileMode false
git reset --hard HEAD
git pull origin master
cd ./local_infrastructure/ || exit

# Create external docker network
echo "127.0.0.1 traefik.docker.local" | sudo tee -a /etc/hosts

# Start infrastructure to create volumes
docker-compose up -d --force-recreate --build

# Copy databases data vo volumes
echo "Starting data importing..."

echo "Import data for MySQL56..."
sudo docker cp ./mysql56_databases/. mysql56:/var/lib/mysql
sudo rm -rf ./mysql56_databases/
echo "Import data for MySQL56 completed"

echo "Import data for MySQL57..."
sudo docker cp ./mysql57_databases/. mysql57:/var/lib/mysql
sudo rm -rf ./mysql57_databases/
echo "Import data for MySQL57 completed"

echo "Import data for MariaDB101..."
sudo docker cp ./mariadb101_databases/data/. mariadb101:/bitnami/mariadb/data/
sudo rm -rf ./mariadb101_databases/
echo "Import data for MariaDB101 completed"

echo "Import data for MariaDB103..."
sudo docker cp ./mariadb103_databases/data/. mariadb103:/bitnami/mariadb/data/
sudo rm -rf ./mariadb103_databases/
echo "Import data for MariaDB103 completed"

echo "All imports completed"
echo "Restarting infrastructure..."

new_certificates=./configuration/certificates.toml
touch $new_certificates

echo "[tls]" >> $new_certificates

readarray -t certificates_lines < ./traefik_rules/rules.toml

for line in "${certificates_lines[@]}"
do
   :
   if [ "$line" == '[[tls]]' ]; then
       echo "  [[tls.certificates]]" >> $new_certificates
       continue
   elif [ "$line" == *"entryPoints = [\"https\"]"* ] || [[ "$line" == *"tls.certificate"* ]] || [[ $line == *"entryPoints"* ]]; then
       continue
   else
       echo "$line" >> $new_certificates
   fi
done

docker-compose down
docker-compose up -d

rm -rf ./traefik_rules

echo "/**********************
*
*    Migration Completed!
*
*    Infrastructure URLS (open and save these URLs to bookmarks):
*    - Docker dashboard URL - http://traefik.docker.local/
*    - phpMyAdmin URL - http://phpmyadmin.docker.local/
*
*    Please, close all applications and reboot!
*
\**********************
"