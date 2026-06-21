FROM debian:bookworm

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y nginx openssl vim netcat-traditional && \
	mkdir -p /etc/nginx/ssl /var/run/nginx /var/www/wordpress && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/cldalmaz.42.fr.key \
	-out /etc/nginx/ssl/cldalmaz.42.fr.crt \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=cldalmaz.42.fr/UID=cldalmaz"

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/wait_wordpress.sh /usr/local/bin/wait_wordpress.sh

RUN chmod +x /usr/local/bin/wait_wordpress.sh && \
	chmod 755 /var/www/wordpress && \
	chown -R www-data:www-data /var/www/wordpress

CMD ["/usr/local/bin/wait_wordpress.sh"]