#!/bin/bash


message=$1
if [ "$1" == "" ]; then
  message="empty message"
fi

git add .
git commit -m "$message"
git push origin master


