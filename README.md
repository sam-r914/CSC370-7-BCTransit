BC Transit Accessibility - CSC 370

Prerequisites
                -   Docker
                    Windows download: https://docs.docker.com/desktop/setup/install/windows-install/
                    Linux download: https://docs.docker.com/desktop/setup/install/linux/
                    Mac download: https://docs.docker.com/desktop/setup/install/mac-install/

Installation & Setup 
                1.  Clone the repository
                    In terminal:
                    - git clone https://github.com/sam-r914/CSC370-7-BCTransit.git
                2.  Open terminal in project directory
                3.  Run the following command:
                    a.  docker compose up --build
                    -   This command should be run everytime the project files change
                4.  Database should now be deployed on your computer!

Shut Down
                To shut down the container follow the following steps:
                1.  In terminal, press ctrl + C twice
                    -   This forces all containers and services to stop
                2.  In terminal, run:
                    -   docker compose down -v
                        -   This ensures all services are stopped and removed
                3.  Container has been successfully shut down