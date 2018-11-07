FROM debian:stretch

RUN useradd -u 1100 postgres && useradd -u 1099 dummyuser

RUN apt-get -y update && \
apt-get -y install wget vim git postgresql && rm -rf /var/lib/apt/lists/*

RUN  mkdir /home/dbbackup && cp -r /var/lib/postgresql/9.6/main/* /home/dbbackup/

COPY ./installjira /installjira
COPY ./dbconfig.xml /var/atlassian/jira-home/dbconfig.xml

RUN cd / && wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-7.12.3-x64.bin \
&& chmod a+x atlassian-jira-software-7.12.3-x64.bin \
&& cd / && ./atlassian-jira-software-7.12.3-x64.bin < ./installjira \
&& rm /atlassian-jira-software-7.12.3-x64.bin \
&& mkdir /home/jira-app-backup/ && cp -r /var/atlassian/jira-app/* /home/jira-app-backup/ \
&& mkdir /home/jira-home-backup/ && cp -r /var/atlassian/jira-home/* /home/jira-home-backup/
RUN cd / && wget https://product-downloads.atlassian.com/software/bitbucket/downloads/atlassian-Bitbucket-5.15.0-x64.bin \
&& chmod a+x atlassian-Bitbucket-5.15.0-x64.bin \
&& cd / && ./atlassian-Bitbucket-5.15.0-x64.bin \
&& rm /atlassian-Bitbucket-5.15.0-x64.bin \
&& mkdir /home/bitbucket-app-backup/ && cp -r /var/atlassian/bitbuket-app/* /home/bitbucket-app-backup/ \
&& mkdir /home/bitbucket-home-backup/ && cp -r /var/atlassian/bitbucket-home/* /home/bitbucket-home-backup/

VOLUME /var/lib/postgresql/9.6/main /var/atlassian/jira-app /var/atlassian/jira-home
VOLUME /var/lib/postgresql/9.6/main /var/atlassian/bitbucket-app /var/atlassian/bitbucket-home

EXPOSE 8080
EXPOSE 5432
EXPOSE 7990

COPY ./entrypoint.sh /entrypoint.sh
COPY ./createdb.sql /createdb.sql

ENTRYPOINT [ "/entrypoint.sh" ]
