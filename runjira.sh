#!/bin/bash
# author Ivan Tichy

if [ -f ${PROJECT_DIR}/jiracid ]; then
  if [ `docker ps -q --no-trunc | grep -c \`cat ${PROJECT_DIR}/jiracid\`` == 1 ]; then
    echo "Running JIRA found ... stopping it."
    docker stop `cat ${PROJECT_DIR}/jiracid`
  fi
rm ${PROJECT_DIR}/jiracid
fi

echo "Starting JIRA"
docker run --cidfile ${PROJECT_DIR}/jiracid --rm -p 8080:8080 \
  -v ${DATA_DIR}/postgres:/var/lib/postgresql/9.5/main \
  -v ${DATA_DIR}/jira-app:/var/atlassian/jira-app \
  -v ${DATA_DIR}/jira-home:/var/atlassian/jira-home \
  llowell/jira-yakkety:7.3.0 "$@" &
echo "docker stop \`cat ${PROJECT_DIR}/jiracid\`" > ${PROJECT_DIR}/stopjira.sh && chmod +x ${PROJECT_DIR}/stopjira.sh
echo "rm ${PROJECT_DIR}/jiracid" >> ${PROJECT_DIR}/stopjira.sh
