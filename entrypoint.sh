#!/bin/bash

# params: purge - destroysall data; noinit - do not touch app and db folders


if [ "$1" != "noinit" ]; then
if [ "$1" = "purge" ]; then

  echo "Cleaning all data..."
  cd /
  killall java
  service postgresql stop
  rm -rf /var/atlassian/jira-app/*
  rm -rf /var/atlassian/jira-home/*
  rm -rf /var/lib/postgresql/9.4/main/*
fi


# empty dirs?
cd /var/atlassian/jira-app
if [ `ls | wc -l` -eq 0 ]; then
  cp -r /home/jira-app-backup/* /var/atlassian/jira-app/
  echo "done" > file
fi

cd /var/atlassian/jira-home
if [ `ls | wc -l` -eq 0 ]; then
  cp -r /home/jira-home-backup/* /var/atlassian/jira-home/
  echo "done" > file
fi

cd /var/lib/postgresql/9.4/main
if [ `ls | wc -l` -eq 0 ]; then
  cp -r /home/dbbackup/* /var/lib/postgresql/9.4/main/
  echo "done" > file 
  chown -R postgres:postgres /var/lib/postgresql/9.4/main
  chmod -R 0700 /var/lib/postgresql/9.4/main
  service postgresql start
  su - postgres << EOF
    cd /
    psql < createdb.sql
EOF
  service postgresql stop
fi

fi
cd /

chown -R jira:jira /var/atlassian/jira-app
chown -R jira:jira /var/atlassian/jira-home
chown -R postgres:postgres /var/lib/postgresql/9.4/main
chmod -R 0700 /var/lib/postgresql/9.4/main

service postgresql start

export JAVA_OPTS=-Djava.net.preferIPv4Stack=true
cd /var/atlassian/jira-app/bin
./start-jira.sh


trap "/var/atlassian/jira-app/bin/stop-jira.sh; service postgresql stop; echo \"Correctly stopped.\"; exit 0" SIGINT SIGTERM

while :
do
        sleep 1
done

