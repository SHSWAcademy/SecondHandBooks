#!/bin/bash
set -e

echo "=== Starting Application ==="

TOMCAT_HOME="/opt/tomcat9"
DEPLOY_DIR="/opt/codedeploy-agent/deployment-root/secondarybook"
WAR_FILE="$DEPLOY_DIR/project-1.0.0-BUILD-SNAPSHOT.war"

# 기존 웹앱 제거
rm -rf $TOMCAT_HOME/webapps/ROOT
rm -rf $TOMCAT_HOME/webapps/ROOT.war

# WAR 파일 복사
if [ -f "$WAR_FILE" ]; then
    cp "$WAR_FILE" "$TOMCAT_HOME/webapps/ROOT.war"
    echo "WAR file deployed"
else
    echo "ERROR: WAR file not found at $WAR_FILE"
    exit 1
fi

# Tomcat 시작
$TOMCAT_HOME/bin/startup.sh

echo "Tomcat started"

# 시작 대기
sleep 10

echo "Application Start completed"
