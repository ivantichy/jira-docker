docker run -it -p 8080:8080  \
-v /var/docker-data/postgres:/var/lib/postgresql/9.4/main \
-v  /var/docker-data/jira-app:/var/atlassian/jira-app \
-v  /var/docker-data/jira-home:/var/atlassian/jira-home \
ivantichy/jira "$@"
