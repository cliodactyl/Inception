FROM debian:bookworm

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && \
	chown mysql:mysql /run/mysqld && \
	chmod 755 /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/run_mariadb.sh /usr/local/bin/run_mariadb.sh

RUN chmod +x /usr/local/bin/run_mariadb.sh

EXPOSE 3306

CMD ["/usr/local/bin/run_mariadb.sh"]