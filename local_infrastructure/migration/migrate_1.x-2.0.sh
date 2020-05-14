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

cd /misc/apps/docker_infrastructure/local_infrastructure/ || exit

export PROJECTS_ROOT_DIR=/misc/apps/
export SSL_CERTIFICATES_DIR=/misc/share/ssl/

echo "
export PROJECTS_ROOT_DIR=/misc/apps/
export SSL_CERTIFICATES_DIR=/misc/share/ssl/" >> ~/.bash_aliases

# Create external docker network
echo "
127.0.0.1 traefik.docker.local" | sudo tee -a /etc/hosts

# Stop infrastructure
docker-compose down

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
sudo docker cp mariadb101_databases/data/. mariadb101:/bitnami/mariadb/data/
echo "Import data for MariaDB101 completed"

echo "Import data for MariaDB103..."
sudo docker cp mariadb103_databases/data/. mariadb103:/bitnami/mariadb/data/
echo "Import data for MariaDB103 completed"

echo "All imports completed"
echo "Restarting infrastructure..."

docker-compose down
docker-compose up -d

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

rm -rf ./traefik_rules
sudo rm -rf ./mariadb10*
sudo rm -rf ./mysql5*

printf "\033[32;1m"
echo "/**********************
*
*    Migration Completed!
*
*    Infrastructure URLS (open and save these URLs to bookmarks):
*    - Docker dashboard URL - http://traefik.docker.local/
*    - phpMyAdmin URL - http://phpmyadmin.docker.local/
*
\**********************
"