#!/bin/bash

sudo apt update && sudo apt install -y openssh-server

sudo useradd -m -s /usr/sbin/nologin sftpuser
echo "sftpuser:password" | sudo chpasswd

echo "
Match User sftpuser
	ForceCommand internal-sftp
	ChrootDirectory /home/sftpuser
	AllowTCPForwarding no
	X11Forwarding no
	PermitTunnel no
	PermitTTY no
" | sudo tee -a /etc/ssh/sshd_config

sudo chown root:root /home/sftpuser && sudo chmod 755 /home/sftpuser
sudo mkdir -p /home/sftpuser/upload && sudo chown sftpuser:sftpuser /home/sftpuser/upload
