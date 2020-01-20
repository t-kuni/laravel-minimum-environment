FROM mysql:8.0.18

COPY init/1-init.sh /docker-entrypoint-initdb.d/
COPY mysql.cnf /etc/mysql/conf.d/mysql.cnf