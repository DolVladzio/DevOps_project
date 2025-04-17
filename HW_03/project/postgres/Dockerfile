FROM postgres:12.0-alpine

ARG POSTGRES_DB
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

ENV POSTGRES_DB=$POSTGRES_DB \
	POSTGRES_USER=$POSTGRES_USER \
	POSTGRES_PASSWORD=$POSTGRES_PASSWORD

COPY backup.dump /docker-entrypoint-initdb.d/backup.dump
COPY init_db.sh /docker-entrypoint-initdb.d/init_db.sh

RUN chmod +x /docker-entrypoint-initdb.d/init_db.sh
