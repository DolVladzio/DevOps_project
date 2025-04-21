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
- Docker(docker images already pushed to the DockerHub)
- K8s

---

### Requirements
- [Git]
- [Docker/Docker-Compose]
- [kubectl]
- [minikube]
- Linux

---

### Creating a local repository
In order to create a local copy of the project you need:
1. Open a terminal and go to the directory where you want to clone the files. 
2. Run the following command:

       git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project/HW_03/k8s

---

### Images
In order to change docker images:
- You can do it here: [deployments]

---

### Configmap
In order to change env
- You can do it here: [configmap]
> Should be the same as for docker images

---

### Launch
1. In order to launch everything:

        bash launch_k8s.sh
> it'll setup all infrastructure

2. To see the result

        kubectl port-forward --address 0.0.0.0 svc/frontend 3000:80 & \
        kubectl port-forward --address 0.0.0.0 svc/backend 8080:8080

[//]: # (Reference links)
[Git]: <https://git-scm.com/downloads/linux>
[Docker/Docker-Compose]: <https://docs.docker.com/engine/install/>
[kubectl]: <https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/>
[minikube]: <https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download>
[deployments]: <https://github.com/DolVladzio/DevOps_project/tree/SCRUM-18-HW_03/HW_03/k8s/deployments>
[configmap]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/k8s/app-config.yml>
