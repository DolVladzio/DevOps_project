############################################################
# from flask import Flask
import paramiko
import os
import re
import psycopg2
from psycopg2 import sql

# app = Flask(__name__)

# DB #######################################################
# db_name = "Logs"
# db_host = '127.0.0.1'
# db_admin_user = 'postgres'
# db_admin_password = 'postgres' 

# try:
#     # Connecting to the 'postgres' database as a superuser
#     connection = psycopg2.connect(
#         dbname="postgres",
#         host=db_host,
#         user=db_admin_user,
#         password=db_admin_password
#     )

#     # Avoiding the "cannot run inside a transaction block" error
#     connection.autocommit = True

#     print(f"Successfully connected to the database 'postgres'.")

#     # Checking/Creating new database and user
#     try:
#         with connection.cursor() as cursor:
#             # Checking/Creating the new database 'Logs'
#             cursor.execute(f"CREATE DATABASE {db_name};")
#             print(f"Database {db_name} was created successfully.")

#             # Checking/Creating a new user 'devops' with password 'devops'
#             cursor.execute(f"CREATE USER {db_admin_user} WITH PASSWORD '{db_admin_password}';")
#             print(f"User {db_admin_user} created successfully.")

#             # Grant privileges to the 'devops' user for the 'Logs' database
#             cursor.execute(f"GRANT ALL PRIVILEGES ON DATABASE {db_name} TO {db_admin_user};")
#             print(f"Privileges granted to {db_admin_user} on database {db_name}.")

#             print("Database setup completed.")
#     except:
#         print(f"- The user {db_admin_user}' already exists\n- The  database {db_name} already exists\n")

# except Exception as e:
#     print(f'- Something went wrong :(\n{e}')

# finally:
#     if 'connection' in locals() and connection:
#         connection.close()
#         print("Connection closed.")
# VM #######################################################
vm_ipc = [
    "192.168.56.101",
    "192.168.56.102",
    "192.168.56.103"
]

vm_username = "sftpuser"
private_key_path = os.path.expanduser("~/.ssh/id_rsa")
logs_file_path = "/home/sftpuser/logs_info.txt"

# Regular expression pattern to match date_time and text
pattern = r"(?P<date_time>\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}) \| (?P<text>.+)"

try:
    # Reading the private key
    key = paramiko.RSAKey.from_private_key_file(private_key_path)
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    # Connecting to the vm
    for ip in vm_ipc:
        print(f"- Connecting to {ip}...")
        ssh.connect(hostname=ip, username=vm_username, pkey=key)
        print(f"- Connected to {ip}\n")

        # Use SFTP to retrieve the logs file
        sftp = ssh.open_sftp()
        print("- Logs retrieving...\n")

        with sftp.file(logs_file_path, "r") as remote_file:
            log_data = remote_file.read().decode("utf-8")

        sftp.close()

        for match in re.finditer(pattern, log_data):
            date_time = match.group("date_time")
            text = match.group("text")
            print(f"{date_time} | {text}")

        print(f"- Logs retrieved successfully from {ip}.\n")

except Exception as e:
    print(f'- Something went wrong :( {e}')
finally:
    if ssh:
        ssh.close()
        print("- SSH connection closed.")

    # Close the connection to PostgreSQL
    # if 'connection' in locals() and connection:
    #     connection.close()
    #     print("- DB's connection closed.")

    print("- The end")
############################################################
# @app.route("/")
# def showLogs():
############################################################
