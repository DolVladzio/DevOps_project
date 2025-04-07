# Runbook to setup everything

## First you need to setup all vms! 

- You have to clone this repository:
```sh
git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project
```

- Generate ssh keys:
```sh
mkdir ssh && cd ssh && ssh-keygen -t rsa -b 4096 -f id_rsa && cd ..
```

- Using the Vargant command, setup all vms:
```sh
vagrant up
```

- After all vms were launched, run this command:
```sh
ssh -o StrictHostKeyChecking=no -i .\ssh\id_rsa sftpuser@xxx.xxx.xxx.xxx
```
