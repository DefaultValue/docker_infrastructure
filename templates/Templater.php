<?php
declare(strict_types=1);

chdir(__DIR__);

class Templater
{
    private $versionSpecificConfig = [
        '7.0' => [
            'additional_libs' => [
                'libmcrypt-dev'
            ],
            'additional_modules' => [
                'bcmath',
                'mcrypt'
            ]
        ],
        // Includes Magento 2.3.2 fix for libsodium lib requirements https://github.com/magento/magento2/issues/23405#issuecomment-506725788
        '7.1' => [
            'additional_libs' => [
                'libmcrypt-dev'
            ],
            'additional_modules' => [
                'bcmath',
                'mcrypt'
            ],
            'additional_run' => <<<BASH
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list ; \
    apt-get update && apt-get -t stretch-backports install -y libsodium-dev ; \
    pecl install -f libsodium-1.0.17
BASH
        ],
        '7.2' => [
            'additional_modules' => [
                'bcmath'
            ],
            'additional_run' => <<<BASH
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list ; \
    apt-get update && apt-get -t stretch-backports install -y libsodium-dev ; \
    docker-php-ext-install sodium
BASH

        ],
        '7.3' => [
            'additional_modules' => [
                'bcmath'
            ]
        ],
    ];

    /**
     * @return void
     */
    public function refreshDockerTemplates(): void
    {
        if (!$template = file_get_contents('./project/docker/Dockerfile')) {
            throw new RuntimeException('Template file not found!');
        }

        foreach ($this->versionSpecificConfig as $phpVersion => $settings) {
            $replacement = [
                '{{php_version}}' => $phpVersion,
                '{{additional_libs}}' => isset($settings['additional_libs'])
                    ? implode(' ', $settings['additional_libs'])
                    : '',
                '{{additional_modules}}' => isset($settings['additional_modules'])
                    ? implode(' ', $settings['additional_modules'])
                    : '',
                '{{additional_run}}' => $settings['additional_run'] ?? ''
            ];

            $dockerfile = str_replace(array_keys($replacement), array_values($replacement), $template);
            $savePath = "./php/$phpVersion";

            if (!is_dir($savePath) && !mkdir($savePath)) {
                throw new RuntimeException('Can not create folder to save template !');
            }

            file_put_contents("$savePath/Dockerfile", $dockerfile);
        }
    }
}

$builder = new Templater();
$builder->refreshDockerTemplates();