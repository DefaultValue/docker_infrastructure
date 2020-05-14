<?php
/**
* Dockerhub build settings:
* templates/php/5.6/development.Dockerfile > 5.6-development
* templates/php/5.6/production.Dockerfile > 5.6-production
* templates/php/7.0/development.Dockerfile > 7.0-development
* templates/php/7.0/production.Dockerfile > 7.0-production
* templates/php/7.1/development.Dockerfile > 7.1-development
* templates/php/7.1/production.Dockerfile > 7.1-production
* templates/php/7.2/development.Dockerfile > 7.2-development
* templates/php/7.2/production.Dockerfile > 7.2-production
* templates/php/7.3/development.Dockerfile > 7.3-development
* templates/php/7.3/production.Dockerfile > 7.3-production
*/

declare(strict_types=1);

chdir(__DIR__);

class Templater
{
    private $versionSpecificConfig = [
        '7.0' => [
            'additional_libs' => [
                'libmcrypt-dev'
            ],
            'additional_modules' => 'bcmath mcrypt',
            'xdebug_version' => '-2.6.0'
        ],
        // Includes Magento 2.3.2 fix for libsodium lib requirements https://github.com/magento/magento2/issues/23405#issuecomment-506725788
        '7.1' => [
            'additional_libs' => [
                'libmcrypt-dev'
            ],
            'additional_modules' => 'bcmath mcrypt sockets',
            'additional_run' => <<<BASH
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list ; \
    apt-get update && apt-get -t stretch-backports install -y libsodium-dev ; \
    pecl install -f libsodium-1.0.17
BASH
        ],
        '7.2' => [
            'additional_modules' => 'bcmath sodium sockets',
            'additional_run' => <<<BASH
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list ; \
    apt-get update && apt-get -t stretch-backports install -y libsodium-dev
BASH

        ],
        '7.3' => [
            'additional_modules' => 'bcmath sodium sockets',
            'additional_run' => <<<BASH
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list ; \
    apt-get update && apt-get -t stretch-backports install -y libsodium-dev
BASH
        ],
    ];

    /**
     * @return void
     */
    public function refreshDockerTemplates(): void
    {
        $templateFiles = [
            './php/dockerfiles/development/Dockerfile',
            './php/dockerfiles/production/Dockerfile'
        ];

        foreach ($templateFiles as $templateFile) {
            $this->processFile($templateFile);
        }
    }

    /**
     * @param string $templateFile
     */
    private function processFile(string $templateFile): void
    {
        if (!$templateFileContent = file_get_contents($templateFile)) {
            throw new RuntimeException('Template file not found!');
        }

        foreach ($this->versionSpecificConfig as $phpVersion => $settings) {
            $replacement = [
                '{{php_version}}' => $phpVersion,
                '{{additional_libs}}' => isset($settings['additional_libs'])
                    ? implode(' ', $settings['additional_libs'])
                    : '',
                '{{additional_modules}}' => $settings['additional_modules'] ?? '',
                '{{additional_run}}' => $settings['additional_run'] ?? '',
                '{{xdebug_version}}' => $settings['xdebug_version'] ?? ''
            ];

            $content = str_replace(array_keys($replacement), array_values($replacement), $templateFileContent);
            $savePath = "./php/$phpVersion";
            $dockerfilePath = array_reverse(explode('/', $templateFile));
            // This was PHPStorm recognizes files as Dockerfile
            $dockerfile = $dockerfilePath[1] . '.' . $dockerfilePath[0];

            if (!is_dir($savePath) && !mkdir($savePath)) {
                throw new RuntimeException('Can not create folder to save template !');
            }

            file_put_contents("$savePath/$dockerfile", $content);
        }
    }
}

$builder = new Templater();
$builder->refreshDockerTemplates();