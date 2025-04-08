##############################################################################
import paramiko
import os
import re
import psycopg2
from psycopg2 import sql

from flask import Flask, render_template

app = Flask(__name__)
##############################################################################
db_name = "logsdatabase"
db_username = "postgres"
db_password = "devops"
db_host = "127.0.0.1"
db_table_name = "logs"
##############################################################################
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
        db_connection.autocommit = True
        cursor = db_connection.cursor()

        try:
            print(f"- Creating the database: '{db_name}'...")
            cursor.execute(sql.SQL("CREATE DATABASE {db};").format(db=sql.Identifier(db_name)))
            print(f"- The database '{db_name}' created successfully.\n")
        except psycopg2.errors.DuplicateDatabase:
            print(f"- The database '{db_name}' already exists.\n")

    except Exception as e:
        print(f'- An exception occurred :(\n{e}')
    
    finally:
        # Close the database connection
        if db_connection:
            cursor.close()
            db_connection.close()
            print("- DB's connection closed.\n-----------------------------")
##############################################################################
def DBConnection():
    try:
        print(f"- Connecting to the database {db_name}...")
        db_connection = psycopg2.connect(
            dbname=db_name,
            user=db_username,
            password=db_password,
            host=db_host
        )
        cursor = db_connection.cursor()
        db_connection.autocommit = True

        print(f"- Connected to the database: {db_name}")
        return db_connection, cursor 
    
    except Exception as e:
        print(f"Failed to connect to the database: {e}")
        raise
##############################################################################
def createTable():
    try:
        db_connection = DBConnection()
        cursor = db_connection.cursor()

        print(f"- Creating the table '{db_table_name}'...")
        sql_command = sql.SQL('''CREATE TABLE IF NOT EXISTS {table} (
            id SERIAL PRIMARY KEY,
            date_time TIMESTAMP NOT NULL,
            text TEXT NOT NULL
        );''').format(table=sql.Identifier(db_table_name))
        cursor.execute(sql_command)
        print(f"- The table '{db_table_name}' created successfully.\n")

    except Exception as e:
        print(f"- An exception occurred :(\n{e}")
    
    finally:
        # Close the database connection
        if db_connection:
            cursor.close()
            db_connection.close()
            print("- DB's connection closed")
##############################################################################
def insertLogs():
    vm_ipc = [
        "192.168.56.101",
        "192.168.56.102",
        "192.168.56.103"
    ]

    vm_username = "sftpuser"
    private_key_path = os.path.expanduser("~/.ssh/id_rsa")
    logs_file_path = "/home/sftpuser/logs_info.txt"
    regex = r"(?P<date_time>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \| (?P<text>.+)"
    ssh = None
    db_connection = None

    try:
        key = paramiko.RSAKey.from_private_key_file(private_key_path)
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        db_connection = DBConnection()
        cursor = db_connection.cursor()

        for ip in vm_ipc:
            print(f"----------------------------\n- Connecting to {ip}...")
            ssh.connect(hostname=ip, username=vm_username, pkey=key)
            print(f"- Connected to {ip}\n")

            sftp = ssh.open_sftp()
            with sftp.file(logs_file_path, "r") as remote_file:
                log_data = remote_file.read().decode("utf-8")

                for match in re.finditer(regex, log_data):
                    date_time = match.group("date_time").replace('_', ' ')
                    text = match.group("text")

                    try:
                        insert_query = sql.SQL("INSERT INTO {table} (date_time, text) VALUES (%s, %s);").format(
                            table=sql.Identifier(db_table_name)
                        )
                        cursor.execute(insert_query, (date_time, text))
                        print(f"- Log inserted: {date_time} | {text}")
                    except Exception as e:
                        print(f"- Failed to insert logs for date_time: {date_time}, text: {text}")
                        print(f"  Error: {e}")

                print(f"\n- Logs retrieved successfully from {ip}")

        sftp.close()

    except Exception as e:
        print(f"- An exception occurred :(\n{e}")
    
    finally:
        # Close the SSH connection
        if ssh is not None:
            ssh.close()
            print("----------------------------\n- SSH connection closed.")
        # Close the database connection
        if db_connection:
            cursor.close()
            db_connection.close()
            print("- DB's connection closed.\n-----------------------------")
##############################################################################
@app.route("/")
def showLogs():
    db_connection = None
    cursor = None
    try:
        # Connect to the database
        db_connection, cursor = DBConnection()

        # Execute the query
        cursor.execute(f"SELECT * FROM {db_table_name};")
        
        # Fetch logs and pass them to the template directly
        logs = cursor.fetchall()

        return render_template("logs.html", logs=logs)

    except Exception as e:
        return render_template("error.html", error_message=f"An error occurred: {e}")

    finally:
        if cursor:
            cursor.close()
        # Close the database connection
        if db_connection:
            cursor.close()
            db_connection.close()
##############################################################################
if __name__ == "__main__":
    createDB()
    createTable()
    insertLogs()
    print("\n- All tasks completed successfully.")

    app.run(debug=True)
##############################################################################
