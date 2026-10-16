# **BC Transit Accessibility - CSC 370**  

## **Project Description**  
This project intends to address the lack of easy-to-access information on the accessibility of BCTransit bus stops. Currently, in order to find out whether or not a specific bus stop is wheelchair accessible, you need to phone the BCTransit office. The idea behind this project is to make that information, as well as other bus stop features, easily accessible online.

## **Prerequisites**  
-   **Docker**  
    Windows download: https://docs.docker.com/desktop/setup/install/windows-install/  
    Linux download: https://docs.docker.com/desktop/setup/install/linux/  
    Mac download: https://docs.docker.com/desktop/setup/install/mac-install/  

## **Installation & Setup**  
1.  Ensure Docker Engine is running (Open Docker App)  
2.  Clone the repository  
    In terminal:  
    - `git clone https://github.com/sam-r914/CSC370-7-BCTransit.git`  
3.  Open terminal in project directory  
4.  To build the container run:  
    -  `docker compose up -d`  
5.  To output specific details regarding bus stops run:  
    -  `docker compose exec data_export sh /export_tables.sh bus_stop`  
    To output all values within bus_routes, bus_stop and route_stops run:  
    -  `docker compose exec data_export sh /export_tables.sh`  
6.  Database should now be deployed on your computer!  

## **Shut Down**  
*To shut down the container follow these steps:*  
1.  In terminal, press ctrl + C twice  
    -   This forces all containers and services to stop  
2.  In terminal, run:  
    -   `docker compose down -v`  
        -   This ensures all services are stopped and removed  
3.  Container has been successfully shut down  
**OR**  
1.  Open Docker  
2.  Navigate to container location  
3.  Manually stop container service