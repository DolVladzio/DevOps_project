# Class schedule
_This repository contains a source code of the Class Schedule Project._

_The main goal of the project is designing a website where the university or institute staff will be able to create, store and display their training schedules._

## Used technologies:
- Node.js
  - React
- Java
  - Gradle
  - Tomcat
- DBs
  - PostgreSQL
  - Redis
  - MongoDB
- Docker/Docker-compose

### Creating a local repository
In order to create a local copy of the project you need:
1. Download and install the last version of Git https://git-scm.com/downloads
2. Open a terminal and go to the directory where you want to clone the files. 
3. Run the following command:

       git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project/HW_03/project

### Databases
In order to configure your own credentials:
- You can do it here: [Credentials]

### Images
In order to change docker's images:
- Frontend's images - [Frontend's image]
- Backend's image - [Backend's image]
- The rest of the services - [All services]

### Launch
1. In order to launch everything:

       docker-compose up -d
> without -d, logs will be showed in real-time
2. Visit - [http://localhost]

[//]: # (Reference links)
[Credentials]: <https://github.com/DolVladzio/DevOps_project/tree/SCRUM-18-HW_03/HW_03/project/src/main/resources>
[Frontend's image]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/frontend/Dockerfile>
[Backend's image]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/Dockerfile>
[All services]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/docker-compose.yml>
[http://localhost]: <http://localhost>
