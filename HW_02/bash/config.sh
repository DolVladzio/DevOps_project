#!/bin/bash
############################################################
# Install OpenSSH
sudo apt update && \
	sudo apt install -y openssh-server

# Create the SFTP user if not exists
id -u sftpuser &>/dev/null || useradd -m -s /bin/bash sftpuser

# Set up .ssh and authorized_keys
mkdir -p /home/sftpuser/.ssh
chmod 700 /home/sftpuser/.ssh

# Add public key from shared folder
if [[ -f /vagrant/ssh/id_rsa.pub ]]; then
	# Add the public key
	cat /vagrant/ssh/id_rsa.pub >> /home/sftpuser/.ssh/authorized_keys
	chmod 600 /home/sftpuser/.ssh/authorized_keys
	chown -R sftpuser:sftpuser /home/sftpuser/.ssh
else
	echo "Public key not found at /vagrant/id_rsa.pub"
fi
############################################################
# Configure to launch the file every 5m
echo "*/5 * * * * ~/vagrant/bash/sent_logs.sh" | crontab -e sftpuser -
############################################################
