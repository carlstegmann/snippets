#!/bin/bash
database="gvmd"
database_user="gvmd"
# start postgres and configure database
su - postgres -c "/usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main -c config_file=/etc/postgresql/12/main/postgresql.conf" &
sleep 3
su - postgres -c "createuser -DRS ${database_user}"
su - postgres -c "createdb -O ${database_user} ${database}"
su - postgres -c "psql -d ${database} -f /psql_init.sql"
echo "psql setup done" > /psql_setup_done
