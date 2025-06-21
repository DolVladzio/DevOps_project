- The correct path to the Dockerfile
```
git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project/jenkins
```

- To build an image correctly:
```
docker build -t jenkins .
```

- To run a container correctly with permissions:
```
docker run -d --name jenkins -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --group-add $(getent group docker | cut -d: -f3) jenkins
```
