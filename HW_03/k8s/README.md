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
- Docker/Docker-compose(already created docker images and pushed to the DockerHub)
- K8s

## Requirements
- [Git]
- [Docker/Docker-Compose]
- [kubectl]
- [minikube]
- Linux

### Creating a local repository
In order to create a local copy of the project you need:
1. Open a terminal and go to the directory where you want to clone the files. 
2. Run the following command:

       git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project/HW_03/k8s

### Images
In order to change docker's images:
- You can do it here: [deployments]

### Launch
1. In order to launch everything:

        bash launch_k8s.sh
> it'll setup all infrastructure

[//]: # (Reference links)
[Git]: <https://git-scm.com/downloads/linux>
[Docker/Docker-Compose]: <https://docs.docker.com/engine/install/>
[kubectl]: <https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/>
[minikube]: <https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download>
[deployments]: <https://github.com/DolVladzio/DevOps_project/tree/SCRUM-18-HW_03/HW_03/k8s/deployments>
