#!/bin/bash

echo "=== Validating Service ==="

# Tomcat 프로세스 확인
if pgrep -f "catalina" > /dev/null; then
    echo "Tomcat is running"
else
    echo "WARNING: Tomcat process not found"
fi

# 포트 확인
sleep 10
if netstat -tlnp 2>/dev/null | grep -q ":8080"; then
    echo "Port 8080 is listening"
else
    echo "WARNING: Port 8080 not listening yet"
fi

echo "Validation completed"
exit 0
