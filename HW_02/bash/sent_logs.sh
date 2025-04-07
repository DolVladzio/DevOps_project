#!/bin/bash
############################################################
HOSTNAME=$(hostname)
date_time=$(date +'%Y-%m-%d_%H-%M-%S')
file_name=logs_info.txt
############################################################
if [[ $HOSTNAME == "server-1" ]]; then
	# Array with ip
	neighbors_ip=("192.168.56.102" "192.168.56.103")
elif [[ $HOSTNAME == "server-2" ]]; then
	# Array with ip
	neighbors_ip=("192.168.56.101" "192.168.56.103")
elif [[ $HOSTNAME == "server-3" ]]; then 
	# Array with ip
	neighbors_ip=("192.168.56.101" "192.168.56.102")
fi
############################################################
for i in "${neighbors_ip[@]}"; do
	# Put the log' info into the file
	file_content="Date-Time: $date_time | Connection created by $HOSTNAME to $i"

	echo "$file_content" | ssh sftpuser@$i "cat >> /home/sftpuser/$file_name"
done
############################################################
