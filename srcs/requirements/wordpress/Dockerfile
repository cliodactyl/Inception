FROM debian:bookworm

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		php8.2 \
		php8.2-fpm \
		php8.2-mysql \
		mariadb-client \
		curl \
		unzip \
		wget \
		vim && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh

RUN chmod +x /usr/local/bin/auto_config.sh && \
	mkdir -p /var/www/wordpress /run/php && \
	chown -R www-data:www-data /var/www && \
	chmod -R 755 /var/www

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]