FROM hshekhar47/debian:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ADD conf/my.cnf /etc/mysql/conf.d/
ADD scripts /usr/bin/

USER root

RUN echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7" >> /etc/apt/sources.list.d/mysql.list && \
    echo "deb-src http://repo.mysql.com/apt/debian/ stretch mysql-5.7" >> /etc/apt/sources.list.d/mysql.list && \
    sudo apt-get update && \
    { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections && \
    sudo apt-get install -y mysql-server --allow-unauthenticated && \
    sudo chmod +x /usr/bin/bootstrap.sh

EXPOSE 3306
ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "/usr/bin/bootstrap.sh && /bin/bash" ]