FROM debian:jessie

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

RUN apt-get install -y wget && \
	echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
	echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
	wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg

RUN apt-get update -y && \
	apt-get install -y \
		git-core \
		curl \
		nginx \
		php5-fpm \
		php5-mysqlnd \
		php5-cli \
		supervisor

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf && \
	sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf && \
	sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf && \
	echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD conf/vhost.conf /etc/nginx/sites-available/default
ADD conf/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

EXPOSE 80 3306

VOLUME ["/data"]
WORKDIR /data

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisor.conf"]
