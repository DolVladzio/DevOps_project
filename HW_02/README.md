# Runbook

A simple project to see how the specific logs can be collected from the vms, inserted into the DB(PostgreSQL) and outputted on a website

## The structure of the project
```sh
.
├── README.md
├── Vagrantfile
├── app
│   ├── docker-compose.yml
│   └── python
│       ├── Dockerfile
│       ├── app.py
│       ├── init_db.py
│       ├── requirements.txt
│       ├── static
│       │   ├── script.js
│       │   └── style.css
│       └── templates
│           ├── error.html
│           └── logs.html
└── bash
    ├── config.sh
    └── sent_logs.sh
```

## Used technologies:
- Python(Flask)
- Vagrant
- PostgreSQL
- Bash
- Docker/Docker-Compose
- HTML/CSS


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

- After all vms were launched, run this command to connect to the main vm:
```sh
vagrant ssh main
```

- Start the docker containers
```sh
cd DevOps_project/HW_02/app && docker-compose up -d
```
> Note: `without -d` is gonna show logs in real time.

- After the containers have been launched, visit [localhost:5000] - to check the result!

[//]: # (These are reference links)
[localhost:5000]: <http://localhost:5000>
