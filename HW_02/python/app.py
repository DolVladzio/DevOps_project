############################################################
# from flask import Flask
import paramiko
import os

# app = Flask(__name__)

# vm_ip = "192.168.56.102"
vm_ipc = [
    "192.168.56.101",
    "192.168.56.102",
    "192.168.56.103"
]

vm_username = "sftpuser"
private_key_path = os.path.expanduser("~/.ssh/id_rsa")
logs_file_path = "/home/sftpuser/logs_info.txt"
############################################################
try:
    # Connecting to the vm
    key = paramiko.RSAKey.from_private_key_file(private_key_path)
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    for ip in vm_ipc:
        ssh.connect(hostname=ip, username=vm_username, pkey=key)
        # Reading logs
        cmd = f"hostname; cat {logs_file_path}"

        stdin, stdout, stderr = ssh.exec_command(cmd)

        error_output = stderr.read().decode().strip()

        if error_output:
            print("- Error:", error_output)
        else:
            for line in stdout:
                print(line.strip())

            print("##########################################\n")
############################################################
except Exception as e:
    print(f'- Something went wrong :( {e}')
finally:
    if ssh:
        ssh.close()
    print("- The end")
############################################################
# @app.route("/")
# def showLogs():
############################################################
