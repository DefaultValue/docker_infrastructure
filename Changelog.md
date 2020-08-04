# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [2.1.0] - 2020-08-04

### Added

- New PHP 7.4 images
- Added full collection of MySQL and MariaDB containers: + MySQL 8.0,  MariaDB 10.2 and MariaDB 10.4.
- Added `pcntl` extension to all Dockerfiles (for example needed for multithread static content deploy in Magento 2).

### Changed

- Bump PHP 7.1, 7.2 and 7.3 to Debian Buster release.
- Stick to xDebug 2.7.2 for PHP 7.0 and 2.9.5 for PHP 7.1 and 7.2

### Removed

- Removed using custom repository for `libsodium` for PHP 7.1, 7.2 and 7.3 due to migration to Debian Buster release.


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