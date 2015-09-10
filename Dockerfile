FROM ttreeagency/php:latest
MAINTAINER Dominique Feyer <dfeyer@ttree.ch>

ENV BOWER_UPDATE=true \
    GULP_UPDATE=true \
    GRUNT_UPDATE=true

# Configure nodejs repository
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -

# Install packages
RUN apt-get update -y && \
	apt-get install -y \
    nodejs \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    ruby-full \
    iptables && \
      npm install -g \
        bower \
        gulp \
        grunt-cli \
        browserify

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

VOLUME /var/lib/docker

CMD ["wrapdocker"]
