# Docker-based PHP development infrastructure. From clean Ubuntu to deployed Magento 2 in 5 commands. #

This is a part of the local infrastructure project which aims to create easy to install and use environment for PHP development based on Ubuntu LTS.

1. [Ubuntu post-installation scripts](https://github.com/DefaultValue/ubuntu_post_install_scripts) - install software,
   clone repositories with `Docker infrastructure` and `Dockerizer for PHP` tool. Infrastructure is launched automatically
   during setup and you do not need start it manually. Check this repo to get more info about what software is installed,
   where the files are located and why we think this software is needed.

2. `Docker infrastructure` (this repository) - run [Traefik](https://traefik.io/) reverse-proxy container with linked
   MySQL 5.6, 5.7, MariaDB 10.1, 10.3, phpMyAdmin and Mailhog containers. Infrastructure is cloned and run automatically by the
   [Ubuntu post-installation scripts](https://github.com/DefaultValue/ubuntu_post_install_scripts). Check this repository
   for more information on how the infrastructure works, how to use xDebug, LiveReload etc.

3. [Dockerizer for PHP](https://github.com/DefaultValue/dockerizer_for_php) - install any Magento 2 version in 1
   command. Add Docker files to your existing PHP projects in one command. This repository is cloned automatically
   by the [Ubuntu post-installation scripts](https://github.com/DefaultValue/ubuntu_post_install_scripts). Please, check
   [Dockerizer for PHP](https://github.com/DefaultValue/dockerizer_for_php) repository to get more information on available
   commands and what the tool does.


## Caution! ##

These images are from the [2.0-development](https://github.com/DefaultValue/docker_infrastructure/tree/2.0-development) branch
and work with the [Dockerizer for PHP v2](https://github.com/DefaultValue/dockerizer_for_php/tree/2.0-develop).
The code is tested to work and will be released in 2-3 days (around  18.05.2020). Meanwhile, you can use v2 branches of these two repositories.


## Local infrastructure ##

Local development infrastructure consists of:
1) Traefik reverse-proxy with dashboard - [http://traefik.docker.local](http://traefik.docker.local)
2) MySQL 5.6 and 5.7, MariaDB 10.1 and 10.3 containers
3) phpMyAdmin - [http://phpmyadmin.docker.local](http://phpmyadmin.docker.local)
4) Mailhog - [http://localhost:8025](http://localhost:8025)

Default Docker network `bridge` is used for all communications.

![Infrastructure schema](https://raw.githubusercontent.com/DefaultValue/docker_infrastructure/master/docker_infrastructure_schema.png)

All infrastructure is cloned and launched by the `Ubuntu post-installation scripts`. You can do this manually if needed:

```bash
mkdir -p ~/misc/apps ~/misc/certs ~/misc/db
cd ~/misc/apps && git clone git@github.com:DefaultValue/ubuntu_post_install_scripts.git
printf '\nexport PROJECTS_ROOT_DIR=${HOME}/misc/apps/' >> ~/.bash_aliases
printf '\nexport SSL_CERTIFICATES_DIR=${HOME}/misc/certs/' >> ~/.bash_aliases
printf '\nexport EXECUTION_ENVIRONMENT=development' >> ~/.bash_aliases

export PROJECTS_ROOT_DIR=${HOME}/misc/apps/
export SSL_CERTIFICATES_DIR=${HOME}/misc/certs/
export EXECUTION_ENVIRONMENT=development

cd ./local_infrastructure/
cp ./configuration/certificates.toml.dist ./configuration/certificates.toml
docker-compose up -d
```

Use the file `./configuration/certificates.toml` to add SSL keys for your project. File watcher is active, so there is
no need to reload/restart Traefik.

After that, you can use Docker files from the folder `./templates/project/` for your project.
Better to use `Dockerizer for PHP` instead of moving and editing the files manually.


## Docker Templates ##

The whole infrastructure consists of the following files:

- `./templates/project/docker-compose.yml` - main compose file with all services. Is used to populate environment
  files as well, so that you can upgrade project infrastructure on the dev/stating servers without affecting the
  production configuration
- `./templates/project/docker-rebuild.sh` - some useful commands for Docker;
- `./templates/project/docker-sync.yml` - for MasOS users (see the respective section at the bottom)
- `./templates/project/docker/.htaccess` - protect the `docker` folder inside your project :)
- `./templates/project/docker/Dockerfile` - Dockerfile based on the official PHP images. Development versions contain Node and Go binary for Mailhog.
- `./templates/project/docker/virtual-host.conf` - Apache2 virtual host file. Easy to share, easy to modify.

If you want to configure the things manually (and learn how the things work):

1) copy the whole `./templates/project` folder to your project root folder;

2) pick up a suitable Dockerfile from the folder `./templates/php/` and replace the one in your project OR
   change the image name to include the appropriate PHP version;

3) change domains, container name etc.;

4) generate ssl certificate with `cd ${SSL_CERTIFICATES_DIR} && mkcert example.com www.example.com`;

5) add an entry to your `/etc/hosts` file.

We strongly recommend using the `SETUP`, `DOCKERIZE` and `ENVADD` aliases from the [Dockerizer for PHP](https://github.com/DefaultValue/dockerizer_for_php)
project instead of manually editing the `docker-compose*.yml` and other files.


## HTTPS is insecure ##

If the certificates generated by `mkcert` are insecure then run the following and restart the browser:

```bash
mkcert -install
```

This may happen because browsers are not started during the software installation and local CA is not trusted yet.


## MySQL ##

MySQL containers can be accessed via the aliases `MY56`, `MY57` etc. aliases for MySQL 5.6 and 5.7 respectively.
You can also directly connect to the MySQL server:

```bash
mysql -uroot -proot -h127.0.0.1 --port=3356 --show-warnings
mysql -uroot -proot -h127.0.0.1 --port=3357 --show-warnings
```

Use `127.0.0.1` in your non-dockerized PHP applications because `localhost` equals to using the socket connection,
not TCP/IP. In the PHP apps use `127.0.0.1:3356` or `127.0.0.1:3357` for PDO connection.

MySQL host name inside your application containers in `mysql` by default. It is determined by the external links in
the `docker-compose.yml` file.

We strongly recommend using separate user name and password for every database like in the real world. Remember
that MySQL and Application containers are different servers. Be sure to allow connection from the application host
or (easier) use `'username'@'%'` to allow connection from any IP. See the security concerns below.


## mysqldump ##

Since all database servers are inside the Docker containers, native `mysqldump` utility from inside the container must be used. The general idea is that:

- a new dump is created inside the container;
- dump file is copied from container to the host filesystem;
- dump is deleted from the container to free up space.

Example creating a *compressed* database dump:

```bash
docker exec -it mysql57 sh -c "mysqldump -u<user> -p <db_name> --no-tablespaces | gzip > /tmp/db.sql.gz"
docker <container> cp mysql57:/tmp/db.sql.gz db.sql.gz
docker exec -it mysql57 rm /tmp/db.sql.gz
```

Example creating an *uncompressed* DB dump:

```bash
docker exec -it mysql57 sh -c "mysqldump -u<user> -p <db_name> --no-tablespaces > /tmp/db.sql"
docker container cp mysql57:/tmp/db.sql db.sql
docker exec -it mysql57 rm /tmp/db.sql
```


## xDebug ##

For PHPStorm launch the website with debug enabled. After accepting the external connection from the container, you
must go to
`Settings > Languages & Frameworks > PHP > Servers` and set `Absolute Path on the Server` to `/var/www/html`. You may
need to restart PHPStorm after this.

For CLI debug run the web debug first (better) or configure `Servers` manually. PHP_IDE_CONFIG equals to the domain name.


## Mailhog ##

Using [Mailhog](https://github.com/mailhog/MailHog) for catching outgoing emails. It is available locally on port `8025`:
[Mailhog local address](http://localhost:8025)

We use [mhsendmail](https://github.com/mailhog/mhsendmail) as a Sendmail replacement. Be sure that your website does not
use external SMTP to send emails. In this case PHP may not control how the emails are sent.


## LiveReload ##

DEPRECATED. Use this  simple [Live Reload](https://chrome.google.com/webstore/detail/live-reload/jcejoncdonagmfohjcdgohnmecaipidc) extension instead. 


## For MacOS users ##

Install [Docker Sync](http://docker-sync.io/) and use `docker-sync.yml` bundled with the project.
Because of the old Linux kernel version on MacOS you should change docker-compose files:
- comment the `user` and `sysctl`
- remove `host.docker.internal:172.17.0.1`


## Security ##

Important! We aim to make local development easy and keep every environment separated from each other. Maintaining native
Docker containers should make it possible to use containers with any delivery/deployment system and keep the things
consistent. though, as you can see, all applications use the same database containers and work in the same network.
You can get some ideas from here and create own infrastructures. But do not try using this infrastructure 'as is'
in production!


## Minor infrastructure upgrades ##

```bash
cd ${PROJECTS_ROOT_DIR}dockerizer_for_php/ || exit
git config core.fileMode false
git pull origin master
rm -rf ./vendor/*
composer install

cd ${PROJECTS_ROOT_DIR}docker_infrastructure/ || exit
git config core.fileMode false
cd ./local_infrastructure/
docker-compose down
git stash
git pull origin master
git stash pop
docker-compose up -d --force-recreate

docker image prune -af
```

Restart your compositions after that if needed.


## Infrastructure migration from v1.x to v2.x ##

Pull changes from the `master` branch and use BASH the script `./local_infrastructure/migration/migrate_1.x-2.0.sh` to upgrade:

```bash
bash ./local_infrastructure/migration/migrate_1.x-2.0.sh
```


## TODO ##

There are yet a lot of features to add, for example:
- Nginx containers;
- Varnish;
- automate ionCube installation;
- etc.

We appreciate help developing this project and still keeping it as 'Docker-native' as possible. Other people should be
able to re-use and easily **extend** containers or compose files for their needs, but not **modify** them.


## Author and maintainer ##

[Maksym Zaporozhets](mailto:maksimz@default-value.com)

[Magento profile](https://u.magento.com/certification/directory/dev/180177/)