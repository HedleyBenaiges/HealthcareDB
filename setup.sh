#!/bin/bash

# Make sure postgres is running
sudo systemctl start postgresql.service

# Move config files to /etc/postgresql/*/main/
sudo mv /etc/postgresql/*/main/postgresql.conf /etc/postgresql/*/main/postgresql.conf.old
sudo mv /etc/postgresql/*/main/pg_hba.conf /etc/postgresql/*/main/pg_hba.conf.old
sudo cp config/* /etc/postgresql/*/main/

# Copy all files to postgres home directory
sudo cp -r ./* /var/lib/postgresql
cd /var/lib/postgresql

# Import database
sudo su - postgres -c "psql -U postgres -c 'CREATE DATABASE \"HealthcareDB\"'"
sudo su - postgres -c "psql -U postgres -f roles.sql"
sudo su - postgres -c "psql -U postgres -d HealthcareDB -f HealthcareDB.sql"
sudo su postgres
