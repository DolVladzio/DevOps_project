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
- Docker/Docker-compose

## Requirements
- [Git]
- [Docker/Docker-Compose]
- Linux

### Creating a local repository
In order to create a local copy of the project you need:
1. Open a terminal and go to the directory where you want to clone the files. 
2. Run the following command:

       git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project/HW_03/project

### Databases
In order to configure your own credentials:
1. Rename this file from [.env_example] to .env
2. Change whatever you want)

### Images
In order to change docker's images:
- Frontend's image - [Frontend's image]
- Backend's image - [Backend's image]
- Postgres's image - [Postgres]
- All services - [All services]

### Launch
1. In order to launch everything:

       docker-compose up -d
> without -d, logs will be showed in real-time
2. Visit - [http://localhost]

[//]: # (Reference links)
[.env_example]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/.env>
[Frontend's image]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/frontend/Dockerfile>
[Backend's image]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/Dockerfile>
[Postgres]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/postgres/Dockerfile>
[All services]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/project/docker-compose.yml>
[http://localhost]: <http://localhost>
[Git]: <https://git-scm.com/downloads/linux>
[Docker/Docker-Compose]: <https://docs.docker.com/engine/install/>
