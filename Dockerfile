# 1. Use the official MySQL base image
FROM mysql:latest

# 2. Set environment variables for initialization
ENV MYSQL_ROOT_PASSWORD=myrootpassword
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# Copy SQL scripts into container's database init folder
COPY init_schema.sql /docker-entrypoint-initdb.d/
COPY load_data.sql /docker-entrypoint-initdb.d/

COPY ./converted-data/route_stops.csv /var/lib/mysql-files/
COPY ./converted-data/routes.csv /var/lib/mysql-files/
COPY ./converted-data/stops.csv /var/lib/mysql-files/

# 3. Expose the standard MySQL port
EXPOSE 3306
