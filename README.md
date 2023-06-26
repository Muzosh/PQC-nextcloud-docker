# Nextcloud-Docker

This repository initializes development instance of PQC-ed Nextcloud server using Docker.

## Installation steps

1. Install Docker and Docker Compose
1. Clone this repository
1. Run `git submodule update --init --remote --recursive` to download sub-repositories
1. **WATCH OUT, key.pem and cert.pem are pre-generated RSA2048 keys to enable https on localhost - do not use in production**
1. Run `docker-compose up -d` to start the server
1. Access the server at `https://localhost:8443` and finish the setup as Nextcloud admin
1. In Nextcloud settings add a new user (for example `testuser`) (you might need to disable "Password Policy" application in Apps settings)
1. Stop and delete the container: `docker-compose down`
1. Rerun `docker-compose -f docker-compose-2fa.yml up -d` to start the server with attached two-factor authentication app
1. Run `docker exec -it pqc-nextcloud-docker-app-1 /bin/bash`
1. In the container run:
   1. `mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini`
   1. `curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer` to install Composer
   1. `su -s /bin/bash www-data` to change user to www-data
   1. `cd /var/www/html/apps/twofactor_webeid` to go to the app directory
   1. `composer install` to install dependencies
   1. `php /var/www/html/occ app:enable twofactor_webeid` to enable the app
   1. `php /var/www/html/occ twofactorauth:enable testuser twofactor_webeid` to enable 2FA for the user
   1. `php /var/www/html/occ user:setting testuser twofactor_webeid subject_cn "testuser"`
   1. `exit`
   1. `exit`
1. Access the server at `https://localhost:8443` and login as testuser

## Development

- changes in `twofactor_webeid` and `twofactor_webeid/vendor/web-eid-authtoken-validation-php` are automatically reflected in the running Nextcloud instance

## XDebug installation (for step-by-step PHP debugging)

1. `docker exec -it <container-ID> /bin/bash`
1. `pecl install xdebug`
1. `docker-php-ext-enable xdebug`
1. add these lines to `/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini`:

   ```
   zend_extension=xdebug
   xdebug.mode=develop,coverage,debug,profile
   xdebug.idekey=docker
   xdebug.log=/dev/stdout
   xdebug.log_level=0
   xdebug.client_port=9003
   xdebug.start_with_request = yes
   ```

1. in VSCode, attach to the container using [Remote Explorer](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug) or [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) extension
1. in the attached container, install [PHP XDebug extension](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)
1. add PHP debug configuration (XDebug should install 3 configurations automatically)
1. run the configuration `Listen for XDebug` to start listening for XDebug connections (might require container restart to work)
1. set some breakpoints in the code and the debugger should stop at them when the webpage is accessed at `https://localhost:8443`
