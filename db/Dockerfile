FROM mysql:8.2

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=todos
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=password

COPY init_db.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
