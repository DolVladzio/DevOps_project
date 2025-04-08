############################################################
# from flask import Flask
import paramiko
import os
import re
import datetime
import sys
import psycopg2
from psycopg2 import sql

# app = Flask(__name__)
############################################################
db_name = "logsdatabase"
db_username = "postgres"
db_password = "devops"
db_host = "127.0.0.1"
db_table_name = "logs"

def createDB():
    try:
        print("-----------------------------\n- Connecting to the database...")
        db_connection = psycopg2.connect(
            dbname="postgres", 
            user=db_username, 
            password=db_password, 
            host=db_host
        )
        print("- Connected to the database.\n")

        cursor = db_connection.cursor()
        db_connection.autocommit = True
        
        # Create the new database
        try:
            print(f"- Creating the database: '{db_name}'...")
            sql = f"CREATE DATABASE {db_name};"
            cursor.execute(sql)
            print(f"- The database '{db_name}' created successfully.\n")
        except psycopg2.errors.DuplicateDatabase:
            print(f"- The database '{db_name}' already exists.\n")
        
    except Exception as e:
        print(f'- An exception occurred :(\n{e}')
    finally:
        if db_connection:
            cursor.close()
            db_connection.close()
            print("- DB's connection closed.\n-----------------------------")
############################################################
def createTable():
    try:
        print(f"- Connecting to the database {db_name}...")
        db_connection = psycopg2.connect(
            dbname=db_name, 
            user=db_username, 
            password=db_password, 
            host=db_host
        )
        print(f"- Connected to the database: {db_name}.\n")
        cursor = db_connection.cursor()
        db_connection.autocommit = True

        # Create the new table
        try:
            print(f"- Creating the table '{db_table_name}'...")
            sql = f'''CREATE TABLE IF NOT EXISTS {db_table_name} (
                id SERIAL PRIMARY KEY,
                date_time TIMESTAMP NOT NULL,
                text TEXT NOT NULL
            );'''
            cursor.execute(sql)
            print(f"- The table '{db_table_name}' created successfully.\n")
        except Exception as e:
            print(f"- The table '{db_table_name}' already exists.\n")

    except Exception as e:
        print(f"- An exception occurred :(\n{e}")
    finally:
        if db_connection:
            cursor.close()
            db_connection.close()
            print("- DB's connection closed.\n-----------------------------")
############################################################
# def insterLogs():
#     vm_ipc = [
#         "192.168.56.101",
#         "192.168.56.102",
#         "192.168.56.103"
#     ]

#     vm_username = "sftpuser"
#     private_key_path = os.path.expanduser("~/.ssh/id_rsa")
#     logs_file_path = "/home/sftpuser/logs_info.txt"

#     # Regular expression pattern to match date_time and text
#     regex = r"(?P<date_time>\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}) \| (?P<text>.+)"

#     try:
#         # Reading the private key
#         key = paramiko.RSAKey.from_private_key_file(private_key_path)
#         ssh = paramiko.SSHClient()
#         ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

#         # Connecting to the vm
#         for ip in vm_ipc:
#             print(f"----------------------------\n- Connecting to {ip}...")
#             ssh.connect(hostname=ip, username=vm_username, pkey=key)
#             print(f"- Connected to {ip}")

#             # Use SFTP to retrieve the logs file data
#             sftp = ssh.open_sftp()
#             print("\n- Logs retrieving...")

#             with sftp.file(logs_file_path, "r") as remote_file:
#                 log_data = remote_file.read().decode("utf-8")

#             sftp.close()
#             print(f"\n- Logs retrieved successfully from {ip}.")

#             # Extracting data from the file using regex
#             for match in re.finditer(regex, log_data):
#                 date_time = match.group("date_time")
#                 text = match.group("text")

#                 # Convert the date_time format to a valid timestamp format
#                 date_time = date_time.replace('_', ' ')

#                 try:
#                     print("- Inserting logs into the database...")
#                     # Convert the string to a Python datetime object
#                     date_time_obj = datetime.datetime.strptime(date_time, "%Y-%m-%d %H-%M-%S")

#                     with connection.cursor() as cursor:
#                         insert_query = sql.SQL("INSERT INTO Logs (date_time, text) VALUES (%s, %s);")
#                         cursor.execute(insert_query, (date_time_obj, text))
#                 except Exception as e:
#                     print(f"- Failed to insert logs into the database :(\n{e}")

#             print(f"- Logs successfully inserted into the database")

#     except Exception as e:
#         print(f'- Something went wrong :( {e}')
#     finally:
#         if ssh:
#             ssh.close()
#             print("- SSH connection closed.")

#         # Close the connection to PostgreSQL
#         if 'connection' in locals() and connection:
#             connection.close()
#             print("- DB's connection closed.")

#         print("- The end")
############################################################
# @app.route("/")
# def showLogs():
############################################################
if __name__ == "__main__":
    createDB()

    createTable()
############################################################
