FROM debian:jessie

RUN useradd -u 1100 postgres && useradd -u 1099 dummyuser

RUN apt-get -y update && \
apt-get -y install wget nano git postgresql && rm -rf /var/lib/apt/lists/*

# backups
RUN  mkdir /home/dbbackup && cp -r /var/lib/postgresql/9.4/main/* /home/dbbackup/

COPY check.gpr /check.gpr
COPY ./installjira /installjira

<<<<<<< HEAD
COPY ./dbconfig.xml /var/atlassian/jira-home/dbconfig.xml

RUN mkdir /home/jira-app-backup/ && cp -r /var/atlassian/jira-app/* /home/jira-app-backup/
RUN mkdir /home/jira-home-backup/ 
RUN cp -r /var/atlassian/jira-home/* /home/jira-home-backup/
=======
RUN cd / && wget https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-7.1.7-jira-7.1.7-x64.bin \
&& sha256sum -c check.gpr \
&& chmod a+x atlassian-jira-software-7.1.7-jira-7.1.7-x64.bin \
&& cd / && ./atlassian-jira-software-7.1.7-jira-7.1.7-x64.bin < ./installjira \
&& rm /atlassian-jira-software-7.1.7-jira-7.1.7-x64.bin \
&& mkdir /home/jira-app-backup/ && cp -r /var/atlassian/jira-app/* /home/jira-app-backup/ \
&& mkdir /home/jira-home-backup/ && cp -r /var/atlassian/jira-home/* /home/jira-home-backup/
>>>>>>> refs/remotes/origin/master

VOLUME /var/lib/postgresql/9.4/main /var/atlassian/jira-app /var/atlassian/jira-home

EXPOSE 8080
EXPOSE 8443

COPY ./entrypoint.sh /entrypoint.sh
COPY ./createdb.sql /createdb.sql

ENTRYPOINT [ "/entrypoint.sh" ]
