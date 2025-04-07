############################################################
# from flask import Flask
import paramiko
import os
import psycopg2
from psycopg2 import sql

# app = Flask(__name__)

# DB #######################################################
db_name="postgres"
db_host = '127.0.0.1'
db_admin_user = 'devops'
db_admin_password = 'devops'

try:
    # Connecting to the DB
    connection = psycopg2.connect(
        dbname=f"{db_name}", 
        host=f"{db_host}", 
        user=f"{db_admin_user}", 
        password=f"{db_admin_password}"
    )

    # Create a new database and user
    with connection.cursor() as cursor:
        cursor.execute(f"CREATE DATABASE {db_name};")
        print(f"Database {db_name} was created successfully.")

        cursor.execute(f"CREATE USER {db_admin_user} WITH PASSWORD {db_admin_password};")
        print(f"User {db_admin_user} created successfully.")
        
        cursor.execute(f"GRANT ALL PRIVILEGES ON DATABASE {db_name} TO {db_admin_user};")
        print(f"Privileges granted to {db_admin_user}.")

    print("Database setup completed.")

except Exception as e:
    print(f'- Something went wrong :( {e}')
# VM #######################################################
vm_ipc = [
    "192.168.56.101",
    "192.168.56.102",
    "192.168.56.103"
]

vm_username = "sftpuser"
private_key_path = os.path.expanduser("~/.ssh/id_rsa")
logs_file_path = "/home/sftpuser/logs_info.txt"

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

except Exception as e:
    print(f'- Something went wrong :( {e}')
finally:
    if ssh:
        ssh.close()
    print("- The end")

    # Close the connection to PostgreSQL
    connection.commit()
    connection.close()
############################################################
# @app.route("/")
# def showLogs():
############################################################
