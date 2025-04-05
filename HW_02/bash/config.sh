#!/bin/bash
############################################################
# Install OpenSSH
sudo apt update && \
	sudo apt install -y openssh-server rkhunter --no-install-recommends

# Create the SFTP user if not exists
id -u sftpuser &>/dev/null || useradd -m -s /bin/bash sftpuser

# Set up .ssh and authorized_keys
mkdir -p /home/sftpuser/.ssh
chmod 700 /home/sftpuser/.ssh
############################################################
# Check if the public/private keys exist
if [[ -f /vagrant/ssh/id_rsa.pub && -f /vagrant/ssh/id_rsa ]]; then
	# Add the public key to the main path
	cat /vagrant/ssh/id_rsa.pub >> /home/sftpuser/.ssh/authorized_keys
	chmod 600 /home/sftpuser/.ssh/authorized_keys
	chown -R sftpuser:sftpuser /home/sftpuser/.ssh

	# Add the private key to the main path
	cat /vagrant/ssh/id_rsa >> /home/sftpuser/.ssh/id_rsa
	chmod 600 /home/sftpuser/.ssh/id_rsa
	chown -R sftpuser:sftpuser /home/sftpuser/.ssh
else
	echo "- The public or private keys weren't found at /vagrant/ssh/"
fi
############################################################
# Check if the file exists
if [[ -f /vagrant/bash/sent_logs.sh ]]; then
	# Add the file to the main path
	cp /vagrant/bash/sent_logs.sh /home/sftpuser/sent_logs.sh
	chmod +x /home/sftpuser/sent_logs.sh
	chown -R sftpuser:sftpuser /home/sftpuser/sent_logs.sh

	# Configure to launch the file every 5m
	echo "*/5 * * * * /home/sftpuser/sent_logs.sh" | crontab -u sftpuser -
else
	echo "- The file 'sent_logs.sh' wasn't found at /vagrant/bash/sent_logs.sh"
fi
############################################################
rkhunter --update
rkhunter --propupd
############################################################
