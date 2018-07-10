#!/bin/bash

chown -R mysql:mysql /var/lib/mysql
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-"s3kr3t"}
MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}
MYSQLD_ARGS=${MYSQLD_ARGS:-""}

tfile=`mktemp`
if [[ ! -f "$tfile" ]]; then
    return 1
fi

cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
EOF

if [[ $MYSQL_DATABASE != "" ]]; then
    echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

    if [[ $MYSQL_USER != "" ]]; then
        echo "GRANT ALL ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> $tfile
    fi
fi
echo "exit" >> $tfile
echo "" >> $tfile

service mysql start
mysql < $tfile
sed -i '/^bind-/ s/^#*/#/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

