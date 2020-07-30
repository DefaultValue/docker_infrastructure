# Changelog

All notable changes to this project will be documented in this file.

See [Readme.md](https://github.com/DefaultValue/dockerizer_for_php/blob/master/Readme.md#upgrade-infrastructure) for upgrade instructions.


## [2.1.0] - 2020-MM-DD

### Added

- Added full collection of MySQL and MariaDB containers: + MySQL 8.0,  MariaDB 10.2 and MariaDB 10.4.
- Added `pcntl` extension to all Dockerfiles (for example needed for multithread static content deploy in Magento 2).


## [2.0.0] - 2020-05-21

### Added

- Volumes for MySQL databases and migration script `./local_infrastructure/migration/migrate_1.x-2.0.sh`
- Mailhog service on port :8025

### Changed

- Moved to Traefik 2.2
- Model all Dockerfiles to [DockerHub](https://hub.docker.com/repository/docker/defaultvalue/php)


## [1.0.1] - 2019-Nov-06

### Added

- `gruntHttp` entrypoint and respective configurations
- MariaDB 10.3 container