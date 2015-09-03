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
    nodejs && \
  npm install -g bower gulp grunt-cli

CMD ["app:start"]
