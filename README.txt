To run this database:

MUST HAVE INSTALLED
Docker 

run these commands within project directory terminal

docker build -t my-db-app .
docker run -d -p 3306:3306 --name mysql-container my-db-app
