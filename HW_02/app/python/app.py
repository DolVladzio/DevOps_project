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

        print(f"- Connected to the database: {db_name}\n")
        return db_connection, cursor

    except Exception as e:
        print(f"Failed to connect to the database: {e}")
        raise
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
def createTable():
    try:
        db_connection, cursor = DBConnection()

        print(f"- Creating the table '{db_table_name}'...")
        sql_command = sql.SQL('''CREATE TABLE IF NOT EXISTS {table} (
            id SERIAL PRIMARY KEY,
            date_time TIMESTAMP NOT NULL,
            text TEXT NOT NULL,
            vm_name VARCHAR(255) NOT NULL
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
            print("- DB's connection closed.\n-----------------------------")
##############################################################################
def getLogs():
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

        db_connection, cursor = DBConnection()

        for ip in vm_ipc:
            print(f"----------------------------\n- Connecting to {ip}...")
            ssh.connect(hostname=ip, username=vm_username, pkey=key)
            print(f"- Connected to {ip}\n")

            command = "hostname"
            # Execute the command to get vm name
            stdin, stdout, stderr = ssh.exec_command(command)

            # Read command output and error
            vm_name = stdout.read().decode('utf-8')
            hostname_error = stderr.read().decode('utf-8')
            
            if hostname_error:
                print(f"Command Error: {hostname_error}")

            sftp = ssh.open_sftp()
            with sftp.file(logs_file_path, "r") as remote_file:
                log_data = remote_file.read().decode("utf-8")
                # Getting the logs from the file
                for match in re.finditer(regex, log_data):
                    date_time = match.group("date_time").replace('_', ' ')
                    text = match.group("text")

                    try:
                        query = f"""
                            SELECT COUNT(*)
                            FROM {db_table_name}
                            WHERE date_time = %s AND text = %s AND vm_name = %s;
                        """
                        cursor.execute(query, (date_time, text, vm_name))
                        count = cursor.fetchone()[0]

                        if count == 0:
                            # Instering the logs into the database
                            insert_query = sql.SQL("""
                                INSERT INTO {table} (date_time, text, vm_name)
                                VALUES (%s, %s, %s);
                            """).format(
                                table=sql.Identifier(db_table_name))
                            cursor.execute(insert_query, (date_time, text, vm_name))
                            print("\n- Logs inserted successfully.")
                        
                        else:
                            continue
                    
                    except Exception as e:
                        print(f'- An exception occurred:(\n{e}')

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

    getLogs()

    try:
        # Connect to the database
        db_connection, cursor = DBConnection()

        # Execute the query
        cursor.execute(f"SELECT date_time, text, vm_name FROM {db_table_name};")

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
