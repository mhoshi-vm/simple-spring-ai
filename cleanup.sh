#!/bin/bash
set -x
cf target -o system -s explore

cf services | egrep -vw "azure-openai-gpt4.1-nano|my-postgres" | sed -e '1,3d' | awk '{print"cf delete-service -f "$1}' | bash -x
cf service-keys azure-openai-gpt4.1-nano | sed '1,3d' | awk '{print"cf delete-service-key azure-openai-gpt4.1-nano -f "$1}' | bash -x
cf service-keys my-postgres | sed '1,3d' | awk '{print"cf delete-service-key my-postgres -f "$1}' | bash -x
cf apps | egrep -vw "prepush" | sed '1,3d' | awk '{print"cf delete -r -f "$1}' | bash -x

find ~/Downloads -name "demo*" -maxdepth 1 -exec rm -rf {} \;
find ~/Library/Application\ Support/JetBrains/ -name "*.http" -exec rm {} \;

RECENT_PROJECTS=`find ~/Library/Application\ Support/JetBrains/ -name recentProjects.xml -exec ls -t {} \; | head -n 1`
cp "$RECENT_PROJECTS" "$RECENT_PROJECTS.bk"
cp "$RECENT_PROJECTS" "$RECENT_PROJECTS.tmp"

xmlstarlet ed -d "//*[starts-with(@key,\"\$USER_HOME\$/Downloads/demo\")]" "$RECENT_PROJECTS.tmp" > "$RECENT_PROJECTS"

curl https://prepush.app.tas.vpsmart.aws.lespaulstudioplus.info/clear