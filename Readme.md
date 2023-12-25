# Docker-based PHP development infrastructure. From clean Ubuntu to deployed Magento 2 in 4 commands. #

This is a part of the local infrastructure project which aims to create easy to install and use environment
for PHP development. Based on Ubuntu LTS.

1. [Ubuntu post-installation scripts](https://github.com/DefaultValue/ubuntu_post_install_scripts): Install all software PHP development with a single script.
2. [Dockerizer](https://github.com/DefaultValue/dockerizer_for_php): Add Docker files to your existing projects in one command. Install any Magento 2 version in 1 command. Dockerizer is a tool for easy creation and management of templates for Docker compositions for your PHP applications. You can use it for development or in the CI/CD pipelines. Check [Dockerizer Wiki](https://github.com/DefaultValue/dockerizer_for_php/wiki) to get more information on available commands and what the tool does.

# Deprecation notice #

This repository will temporarily keep PHP Dockerfiles, and we plan to move it to a more suitable namespace.
Dockerizer v3.2 includes Traekif composition template, which makes this repository obsolete.

## Author and maintainer ##

[Maksym Zaporozhets](mailto:maksimzaporozhets@gmail.com)

P.S.: We appreciate any help developing this project and still keeping it as 'Docker-native' as possible. Other people should be
able to re-use and easily **extend** containers or compose files for their needs, but not **modify** them.