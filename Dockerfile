FROM debian:jessie

RUN useradd -u 1100 postgres && useradd -u 1099 dummyuser

RUN apt-get -y update && \
apt-get -y install wget nano git postgresql

# backups
RUN  mkdir /home/dbbackup && cp -r /var/lib/postgresql/9.4/main/* /home/dbbackup/

RUN cd / && wget https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-7.1.4-jira-7.1.4-x64.bin
RUN chmod a+x atlassian-jira-software-7.1.4-jira-7.1.4-x64.bin

COPY ./installjira /installjira
RUN cd / && ./atlassian-jira-software-7.1.4-jira-7.1.4-x64.bin < ./installjira
RUN rm /atlassian-jira-software-7.1.4-jira-7.1.4-x64.bin

RUN mkdir /home/jira-app-backup/ && cp -r /var/atlassian/jira-app/* /home/jira-app-backup/
RUN mkdir /home/jira-home-backup/ && cp -r /var/atlassian/jira-home/* /home/jira-home-backup/

VOLUME /var/lib/postgresql/9.4/main /var/atlassian/jira-app /var/atlassian/jira-home /var/hostdir

EXPOSE 8080
EXPOSE 8443

COPY ./entrypoint.sh /entrypoint.sh
COPY ./createdb.sql /createdb.sql

ENTRYPOINT [ "/entrypoint.sh" ]
