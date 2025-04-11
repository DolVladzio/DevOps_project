# Runbook

_A simple project to see how the specific logs can be collected from the vms, inserted into the DB(PostgreSQL) and outputted on a website_

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


## To launch this, you need to do the next steps:

- You have to clone this repository:
```sh
git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project
```

- Generate ssh keys:
```sh
mkdir ssh && cd ssh && ssh-keygen -t rsa -b 4096 -f id_rsa && cd ..
```
> Note: `the ssh keys are needed to connect to the vms` .

- Using the Vargant command, setup all vms:
```sh
vagrant up
```

- After all vms were launched, run this command to connect to the main vm:
```sh
vagrant ssh main
```
> Note: `we're connecting to the main vm to launch the Python's app` .

- Start the docker containers
```sh
cd DevOps_project/HW_02/app && docker-compose up -d
```
> Note: `without -d` logs will be showed in real time.

_After the containers have been launched, visit [localhost:5000] - to check the result!_

[//]: # (These are reference links)
[localhost:5000]: <http://localhost:5000>
