# Ansible
_This repository contains the Ansible files to configure vm(-s)_

_The main goal of this task is undesrstand how it's easy to configure different vms via Ansible_

## Used technologies:
- Ansible
- SSH
- Docker/Docker-compose

## Requirements
- [Git]
- Linux
- [Ansible](on your vm and on the other vms with you're going to configure)

### Creating a local repository
In order to create a local copy of the project you need:
1. Open a terminal and go to the directory where you want to clone the files. 
2. Run the following command:
```bash
git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project/HW_03/cloud/ansible
```

### Create SSH keys
```bash
ssh-keygen -t rsa -b 4096 -f id_rsa && mv id_rsa ~/.ssh/id_rsa && mv id_rsa.pub ~/.ssh/authorized_keys
```
> 
### IPs
In order to configure vm's ip:
- You can do it here: [inventory.ini]

### Playbook
In order to configure what you wanna do with your vm(-s):
- You can do it here: [playbook.yml]

### Launch
1. In order to launch:
```bash
ansible-playbook -i inventory.ini playbook.yml
```

[//]: # (Reference links)
[Git]: <https://git-scm.com/downloads/linux>
[Docker/Docker-Compose]: <https://docs.docker.com/engine/install/>
[Ansible]: <https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html>
[inventory.ini]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/cloud/ansible/inventory.ini>
[playbook.yml]: <https://github.com/DolVladzio/DevOps_project/blob/SCRUM-18-HW_03/HW_03/cloud/ansible/playbook.yml>
