FROM debian:jessie

ENV TTREE_VERSION=1.0.0 \
    TTREE_DATA_DIR="/data" \
    FLOW_CONTEXT=Production \
    FLOW_REWRITEURLS=1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

# Configure locales
RUN apt-get install -y locales && \
	dpkg-reconfigure locales && \
	locale-gen C.UTF-8 && \
	/usr/sbin/update-locale LANG=C.UTF-8 && \
	echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get install -y wget curl && \
	echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
	echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
	wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg && \
  curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -

RUN apt-get update -y && \
	apt-get install -y \
    git-core \
    nodejs \
    nginx \
    php5 \
    php5-cli \
    php5-curl \
    php5-xsl \
    php5-gd \
    php5-mcrypt \
    php5-memcache \
    php5-redis \
    php5-fpm \
    php5-mysqlnd \
    supervisor

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf && \
	sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf && \
	sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf && \
	echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  npm install -g bower gulp grunt-cli

ADD conf/vhost.conf /etc/nginx/sites-available/default
ADD conf/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

EXPOSE 80/tcp

VOLUME ["${TTREE_DATA_DIR}"]
WORKDIR ${TTREE_DATA_DIR}

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
