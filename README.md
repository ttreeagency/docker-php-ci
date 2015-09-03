# ttreeagency/php-ci:latest

Official ttreeagency docker container for PHP application running on Gitlab CI.

This container contain the following software:

- Nginx + PHP CLI/FPM (from Dotdeb respository)
- NPM
- GIT
- Composer, the PHP package manager, automatically updated on container start
- Bower, the JS package manager, automatically updated on container start (check Available Configuration Parameters, to disable automatic update)
- Gulp, the JS automation tools, automatically updated on container start (check Available Configuration Parameters, to disable automatic update)
- Grunt, the JS automation tools, automatically updated on container start (check Available Configuration Parameters, to disable automatic update)

This container is under development, change can happen at any time ...

## Version

Current Version: `1.0.0`

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/ttreeagency/docker-php-ci/issues) they may encounter

# Installation

Pull the image from the docker index. This is the recommended method of installation as it is easier to update image. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull ttreeagency/php-ci:latest
```
Alternately you can build the image locally.

```bash
git clone https://github.com/ttreeagency/docker-php-ci.git
cd docker-php-ci
docker build --tag=$USER/php-ci .
```

# Quick Start

You can manually launch the container.

```bash
docker run --name php-ci -d \
    ttreeagency/php-ci:latest
```

If you build the container manually, you can test it with::

```bash
docker run -i -t -p "8080:80" -P --name php-ci -v $PWD/data:/data ttreeagency/php-ci
```

Point your browser to: ```http://localhost:8080```, you should see the output of phpinfo().

You can start any binary available in the container::

```bash
docker run ttreeagency/php-ci:latest php -v
```

You can available options::

```bash
docker run ttreeagency/php-ci:latest app:help
```

### Available Configuration Parameters

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command. Alternately you can use docker-compose.*

Below is the complete list of available options that can be used to customize your gitlab installation.

Check base image for [existing constants](https://github.com/ttreeagency/docker-php/issues)

Bellow the constants specific to this container:

- **BOWER_UPDATE**: Update bower on container start. Defaults to `true`.
- **GULP_UPDATE**: Update gulp on container start. Defaults to `true`.
- **GRUNT_UPDATE**: Update grunt on container start. Defaults to `true`.
