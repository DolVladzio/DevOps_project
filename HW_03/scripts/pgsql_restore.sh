#!/bin/bash

#change on your path to PostgreSQL
#pathA=/c/Program\ Files/PostgreSQL/13/bin
#export PATH=$PATH:$pathA

#write your password
PGPASSWORD=$DB_PASSWORD
export PGPASSWORD

#change the path to the file from which will be made restore
backupPath=/backup/backup.dump
#write your user
dbUser=$DB_USER
#write your database
database=$DB_NAME
#write your host
host=$DB_HOST
#write your port
port=$DB_PORT

# Check if the file exists
if [[ ! -f $backupPath ]]: then
	echo "- The file $backupPath wasn't found"
	exit 1
fi

psql -U $dbUser -h $host -p $port -d $database -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
psql --set ON_ERROR_STOP=off -U $dbUser -h $host -p $port -d $database -1 -f $backupPath

unset PGPASSWORD

echo "- The DB restored successfully)"
