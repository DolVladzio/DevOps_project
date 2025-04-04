# Runbook to setup everything

- First you have to clone this repository:
```sh
git clone https://github.com/DolVladzio/DevOps_project.git && cd DevOps_project
```

- Generate ssh keys:
```sh
mkdir ssh && cd ssh && ssh-keygen -t rsa -b 4096 -f id_rsa && cd ..
```

- Using the Vargant command, setup vms:
```sh
vagrant up
```

- Then you need to use this command:
```sh
cat /vagrant/ssh/id_rsa > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
```
