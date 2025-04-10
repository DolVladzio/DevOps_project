# Runbook to setup everything

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

- After the containers have been launched, visit [localhost:5000] - website to check the result!

[//]: # (These are reference links)
[localhost:5000]: <http://localhost:5000>
