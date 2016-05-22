#!/bin/bash
# author Ivan Tichy

if [ -f ~/jiracid ]; then
  if [ `docker ps -q --no-trunc | grep -c \`cat ~/jiracid\`` == 1 ]; then
    docker stop `cat ~/jiracid`
  fi
rm ~/jiracid
fi

docker run --cidfile ~/jiracid --rm -p 8080:8080 -v /var/docker-data/postgres:/var/lib/postgresql/9.4/main -v /var/docker-data/jira-app:/var/atlassian/jira-app -v /var/docker-data/jira-home:/var/atlassian/jira-home ivantichy/jira:7.1.4 "$@" &

echo "docker stop \`cat ~/jiracid\`" > ~/stopjira.sh && chmod +x ~/stopjira.sh
echo "rm ~/jiracid" >> ~/stopjira.sh


