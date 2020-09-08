#!/bin/sh

#
# Installing database
#
yum upgrade;
yum install -y MariaDB-server MariaDB-client MariaDB-shared;

#
# Remove old information
#
service mariadb stop

#
# This required for new installation of MariaDB
#
# rm -rf /var/lib/mysql/*

#
# Copy configuration files from /etc/my.cnf.d/
#
restorecon -F /etc/my.cnf.d/*
chmod o+r /etc/my.cnf.d/*
chown root:root /etc/my.cnf.d/*

#
# After adding permission to work with more files, reload daemon
#
systemctl daemon-reload

#
# Configuring database logs
#
mkdir /var/log/mariadb;
chown mysql:mysql /var/log/mariadb/;
restorecon -R -F /var/log/mariadb/;

#
# Configuring database
#
mysql_install_db --user=mysql
chcon -R system_u:object_r:mysqld_db_t:s0 /var/lib/mysql/
rm -rf /var/lib/mysql/ib_logfile*
service mariadb restart;
systemctl enable mariadb;
mysql_secure_installation;

#
# Disabling history of mysql client
#
rm -f $HOME/.mysql_history;
ln -s /dev/null $HOME/.mysql_history;
