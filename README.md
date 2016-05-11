# JIRA in Docker container

Welcome to JIRA docker image. What is this? This is simply something that have been missing over the whole Internet. Some fully automated one click JIRA installation. I tried to use Puppet, but official JIRA Puppet Forge stuff was obsolete.

**You can get clean JIRA installation this way:**

`docker run -it -p 8080:8080  ivantichy/jira`

**The result is running JIRA listening on port 8080.**

As a part of the installation there is PostgreSQL database. First time you run JIRA, go to http://yourmachine:8080 and set up JIRA. It will give you a few questions.

1. You want to configure JIRA yourself.
2. You want to use your own database.
3. Database type is PostgreSQL, hostname is localhost, port is default, database is jiradb, user is jiradb, password is jiradb, Schema is public.

PostgreSQL is not listening to communication from outside so it is not such a big issue. You can change jiradb user password in PostgreSQL (google it :) and then change dbconfig.xml in JIRA app/home dir to reflect this change. 

I removed HTTPS support from JIRA container as this should be managed by separate container doing proxy/loadbalancing.

# Volumes, data storage, data backup and restore, migration of jira instances

When you run conainer using command like mentione above `docker run -it -p 8080:8080  ivantichy/jira` your database data, JIRA home directory containing attachments, backups etc, JIRA application directory are stored using volumes on host machine (not inside containcer). You can find information about physical location using `docker inspect <container_name>`. To get your container name use `docker ps`. To find volumes location look for "mount" section in the printed output.

## To use your own path for app data

I personally start the container using this command: `docker run -it -p 8080:8080 -v /var/docker-data/postgres:/var/lib/postgresql/9.4/main -v  /var/docker-data/jira-app:/var/atlassian/jira-app -v  /var/docker-data/jira-home:/var/atlassian/jira-home ivantichy/jira "$@"`. This causes that docker daemon uses paths I selected (/var/docker-data/). I usually backup these folders and I use them to migrate jira from one location to another. These folders survive container deletion which is important. 

## How to set it up

1. Create these folders:
 * `mkdir -p /var/docker-data/postgres`
 * `mkdir -p /var/docker-data/jira-app`
 * `mkdir -p /var/docker-data/jira-home`
2. Migrate your data if you have some (old JIRA) - see description bellow. Do nothing when you do not need to migrate anything.

3. Create a start script executing: `echo "docker run -it -p 8080:8080 -v /var/docker-data/postgres:/var/lib/postgresql/9.4/main -v  /var/docker-data/jira-app:/var/atlassian/jira-app -v  /var/docker-data/jira-home:/var/atlassian/jira-home ivantichy/jira \"$@\"" > ~/runjira.sh && chmod +x ~/runjira.sh`

4. Run JIRA using this command `~/runjira.sh`. Container will set permitions on folders in step 1 (postgresql:1100, jira:1200) so count with that. This is needed because jira and db is not running as root.

5. Set up JIRA (see description in the begining of this file), you can use trial licence to start working with JIRA.

## Backup
When you backup:

* `/var/docker-data/postgres`
* `/var/docker-data/jira-app`
* `/var/docker-data/jira-home`
 
Then you are safe. You should set up database backups inside JIRA application. Your backups will be automatically saved into your JIRA home directory as zip files and you can use them to restore JIRA database later.

- TBD


Note: Inside the container JAVA is running with -Djava.net.preferIPv4Stack=true directive to force Tomcat to listen on IPv4.
