# JIRA in Docker container

Welcome to JIRA docker image. What is this? This is simply something that have been missing over the whole Internet. Some fully automated one click JIRA installation. I tried to use Puppet, but official JIRA Puppet Forge stuff was obsolete.

*You can get clean JIRA installation this way:*

docker run -it -p 8080:8080  ivantichy/jira

*The result is running JIRA listening on port 8080.* 

As a part of the installation there is PostgreSQL database. First time you run JIRA, go to http://yourmachine:8080 and set up JIRA. It will give you a few questions.
You want to configure JIRA yourself.
You want to use your own database.
Database type is PostgreSQL, hostname is localhost, port is default, database is jiradb, user is jiradb, password is jiradb, Schena is public.

PostgreSQL is not listening to communication from outside so it is not such a big issue. You can change jiradb user password in PostgreSQL (google it :) and then change dbconfig.xml in JIRA app/home dir to reflect this change. 

I removed HTTPS support from JIRA container as this should be managed by separate container doing proxy/loadbalancing.

# Volumes, data storage, data backup and restore, migration of jira instances

VOLUME /var/lib/postgresql/9.4/main /var/atlassian/jira-app /var/atlassian/jira-home /var/hostdir
TBD
