# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# [2.4.0] - 2023.12.25

### Added

- New PHP 8.3 images
- Multiplatform build script `docker-images-build-multiplatform.sh`.

### Changed

- Image update policy: new versions or fixes will always have a new tag. Old tags will not be updated.
- Image tags now contain the full PHP version (e.g. `8.3.6-development` instead of `8.3-development`) for explicit versioning.


# [2.3.0] - 2023.06.22

### Added

- Added digest (sha256) to PHP images

### Changed

- Changed commands delimiter from `;` to `&&`
- Now all development Dockerfiles are based on the production ones

### Removed

- Removed the external `composer-proxy` script


## [2.2.4] - 2023.06.16

### Changed

- Readme update after the Dockerizer 3.2.0 release. Removed all information about using this repository as a part of the development environment.


## [2.2.3] - 2023.03.20

### Deprecated

- Deprecated the entire projects. In the nearest future, it will only keep the PHP Dockerfiles. Everything related to the `local_infrastructure` is not supported anymore, and soon will be removed.


### Removed

- Dockerizer 1/2 project templates


## [2.2.2] - 2022.09.02

### Changed

- PHP `memory_limit` set to `2048M` for 7.4-8.1. Composer is always run with `php -d memory_limit=4096M ` (see `./docker/composer-proxy`)


## [2.2.1] - 2022.05.03

Preparing to Dockerizer v3 release.

### Changed

- Run `apt upgrade` before installing packages to have latest and more secure environment.
- Changed network mode to `host`, removed port mappings.

### Removed

- Livereload configuration on ports `35729` and `35730`. Use this  simple [Live Reload](https://chrome.google.com/webstore/detail/live-reload/jcejoncdonagmfohjcdgohnmecaipidc) extension instead.
- Port bindings for Traefik due to the network mode change.


## [2.2.0] - 2021-04-22

### Added

- Using COMPOSER_VERSION environment variable for PHP 7.2-7.4 images. Images new include two composer versions, v2 is default
- Added `mysqli` extension to all containers to support Wordpress and other apps that do not use PDO
- Added `log_bin_trust_function_creators` To MySQL config to enable creating triggers by the users without the SUPER privileges. Otherwise, Magento can't create reindex triggers

### Changed

- Updated xDebug to v3 for PHP 7.4
- Increased memory limit to 3G for PHP 7.3 and 7.4 to handle `composer install` for Magento
- Updated MySQL container settings due to the configuration changes by the vendor

### Removed

- Removed the `recode` extension from PHP 7.4 image


## [2.1.0] - 2020-08-04

### Added

- New PHP 7.4 images
- Added full collection of MySQL and MariaDB containers: + MySQL 8.0,  MariaDB 10.2 and MariaDB 10.4
- Added `pcntl` extension to all Dockerfiles (for example needed for multithread static content deploy in Magento 2)

### Changed

- Bump PHP 7.1, 7.2 and 7.3 to Debian Buster release
- Stick to xDebug 2.7.2 for PHP 7.0 and 2.9.5 for PHP 7.1 and 7.2

### Removed

- Removed using custom repository for `libsodium` for PHP 7.1, 7.2 and 7.3 due to migration to Debian Buster release


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