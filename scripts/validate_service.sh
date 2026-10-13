#!/bin/bash
set -e
echo "Validating service health..."

# App is published on host port 80 via docker-compose 80:8080.
# actuator is exposed with management.endpoints.web.exposure.include=*
# and no management base-path override, so health is served at /actuator/health.
HEALTH_URL="http://localhost/actuator/health"

MAX_RETRIES=12
COUNT=0

while [ $COUNT -lt $MAX_RETRIES ]; do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL" || true)
    echo "Attempt $((COUNT+1)): HTTP_CODE=$HTTP_CODE for $HEALTH_URL"
    if [ "$HTTP_CODE" == "200" ]; then
        echo "Service is healthy."
        exit 0
    fi
    sleep 10
    COUNT=$((COUNT+1))
done

echo "Service failed to start."
echo "Last HTTP_CODE was not 200 after $MAX_RETRIES attempts."
docker-compose logs app
exit 1
