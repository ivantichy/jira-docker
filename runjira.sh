#!/bin/bash
# author Ivan Tichy

docker run --cidfile ~/jiracid --rm -p 8080:8080 -v /var/docker-data/postgres:/var/lib/postgresql/9.4/main -v /var/docker-data/jira-app:/var/atlassian/jira-app -v /var/docker-d$

echo "docker stop \`cat ~/jiracid\`" > ~/stopjira.sh && chmod +x ~/stopjira.sh
echo "rm ~/jiracid" >> ~/stopjira.sh


