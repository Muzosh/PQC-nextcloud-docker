# Nextcloud-Docker

This repository initializes development instance of PQC-ed Nextcloud server using Docker.

## Installation steps

1. Install Docker and Docker Compose
1. Clone this repository
1. Run `git submodule update --init --remote --recursive` to download sub-repositories
1. **WATCH OUT, key.pem and cert.pem are pre-generated RSA2048 keys to enable https on localhost - DO NOT USE THEM IN PRODUCTION**
   - to generate your own, run `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem`
1. Run `docker-compose up -d` to start the server
1. Access the server at `https://localhost:8443`

## Development

- changes in `nextcloud_apps/twofactor_webeid` are automatically reflected in the running Nextcloud instance

## XDebug installation (for step-by-step PHP debugging)

1. In `Dockerfile`, make sure the DEBUG commands are enabled
1. in VSCode, attach to the container using [Remote Explorer](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug) or [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) extension
1. in the attached container, install [PHP XDebug extension](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)
1. add PHP debug configuration (XDebug should install 3 configurations automatically)
1. run the configuration `Listen for XDebug` to start listening for XDebug connections (might require container restart to work)
1. set some breakpoints in the code and the debugger should stop at them when the webpage is accessed at `https://localhost:8443`

## References

- allowing HTTPS: <https://help.nextcloud.com/t/howto-running-nextcloud-over-self-signed-https-ssl-tls-in-docker/101973>
