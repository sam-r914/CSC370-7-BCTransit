# Use the official MySQL base image
FROM mysql:latest

# Expose the standard MySQL port
EXPOSE 3306

WORKDIR /src
COPY SQL_queries/ /src/
