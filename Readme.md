# Docker-based PHP development infrastructure. From clean Ubuntu to deployed Magento 2 in 5 commands. #

This is a part of the local infrastructure project which aims to create easy to install and use environment for PHP development based on Ubuntu LTS.

1. [Ubuntu post-installation scripts](https://github.com/DefaultValue/ubuntu_post_install_scripts) - install software, clone repositories with `Docker infrastructure` and
`Dockerizer for PHP` tool. Development completed, will be released soon;

2. `Docker infrastructure` - run [Traefik](https://traefik.io/) reverse-proxy container with linked MySQL 5.6, 5.7 and
phpMyAdmin containers;

3. [Dockerizer for PHP](https://github.com/DefaultValue/dockerizer_for_php) - install any Magento 2 version in one command. Add Docker files for you PHP projects
in one command.


## Local infrastructure ##

Local development infrastructure consists of:
1) Traefik reverse-proxy with dashboard available at http://localhost:8080
2) MySQL 5.6 and 5.7 containers
3) phpMyAdmin - http://phpmyadmin.docker.local 

Default Docker network `bridge` is used for all communications.

![Infrastructure schema](https://raw.githubusercontent.com/DefaultValue/docker_infrastructure/master/docker_infrastructure_schema.png)

All infrastructure is cloned and launched by the `Ubuntu post-installation scripts`. You can do this manually if needed
as follows:

```bash
cd /misc/apps/docker_infrastructure/local_infrastructure
cp ./traefik_rules/rules.toml.dist ./traefik_rules/rules.toml
docker-compose up -d
```

Use the file `/misc/apps/docker_infrastructure/traefik_rules/rules.toml` to add SSL keys for your project. File watcher
is active, so there is no need to reload/restart Traefik.

After that, you can use Docker files from the folder `/misc/apps/docker_infrastructure/templates` for your project.
Better to use `Dockerizer for PHP` instead of moving and editing the files manually.


## Docker Templates ##

*!!! IMPORTANT !!!*
Soon we plan to upload all Dockerfiles to DockerHub. So, every file will be split into two separate files - development
and production. Please, follow new releases!

The whole infrastructure consists of the following files:

- `./templates/project/docker-compose.yml` - main 'production' compose file with all services;
- `./templates/project/docker-compose-dev.yml` - development domains, xDebug, running Apache inside container as
1000:1000 which is default user/group IDs in Ubuntu. Suitable for easy local development.
- `./templates/project/docker-rebuild.sh` - some useful commands for Docker;
- `./templates/project/docker-sync.yml` - for MasOS users (see the respective section at the bottom)
- `./templates/project/docker/.htaccess` - protect the `docker` folder inside your project :)
- `./templates/project/docker/Dockerfile` - Dockerfile based on the official PHP images. Soon will be split into
separate development and production files.
- `./templates/project/docker/virtual-host.conf` - Apache2 virtual host file. Easy to share, easy to modify.

If you want to configure the things manually (and learn how the things work):

1) copy the whole `./templates/project` folder to your project root folder;

2) pick up a suitable Dockerfile from the folder `./templates/php/` and replace the one in your project;

3) change domains, container name etc.;

4) generate ssl certificate with `cd /misc/share/ssl && mkcert example.com www.example.com`;

5) add an entry to your `/etc/hosts` file.

For development, run the project container as following:

```bash
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d --build --force-recreate
```

## MySQL ##

MySQL containers can be accessed via the aliases `MY56` and `MY57` for MySQL 5.6 and 5.7 respectively. You can also
directly connect to MySQL:

```bash
mysql -uroot -proot -h127.0.0.1 --port=3356 --show-warnings
mysql -uroot -proot -h127.0.0.1 --port=3357 --show-warnings
```

Use `127.0.0.1` in your non-dockerized PHP applications because `localhost` equals to using the socket connection,
not TCP/IP.

MySQL host name inside your application containers in `mysql` by default. It is determined by the external links in
the `docker-compose.yml` file.

We strongly recommend using separate user name and password for every database like in the real world. But remember
that MySQL and Application containers are different servers. Be sure to allow connection from the application host
or (easier) use `'username'@'%'` to allow connection from any IP. See the security concerns below.


## xDebug ##

For PHPStorm launch the website with debug enabled. After accepting the external connection from the container, you
must go to
`Settings > Languages & Frameworks > PHP > Servers` and set `Absolute Path on the Server` to `/var/www/html`. You may
need to restart PHPStorm after this.

For CLI debug run the web debug first (better) or configure `Servers` manually. PHP_IDE_CONFIG equals to the domain name.


## LiveReload ##

All containers include NodeJS and Grunt for development. Default LiveReload extension for Chrome does not support
loading `livereload.js` from the 'remote' server. Please, build and use a forked version that supports these
features: [LiveReload fork](https://github.com/lokcito/livereload-extensions)


## Generating Magento URN catalog for XML files markup highlight, autocomplete and validation ##

```bash
php bin/magento dev:urn-catalog:generate .idea/misc.xml
```

URN catalog uses paths absolute filesystem paths. This is why it must be generated from your host Ubuntu system.
Generating catalog does not require a database connection or any special settings. Though, do not forget to switch
to the proper PHP version - the same that is inside the container. Use aliases to do this - `PHP56`, `PHP70`, `PHP71` etc.

If generating XSD path mappings from the host system does not work fine then most likely Magento codebase experiences
serious issues due to the poorly coded modules.


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