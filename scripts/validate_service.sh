#!/bin/bash
set -e
echo "Validating service health..."
MAX_RETRIES=12
COUNT=0

while [ $COUNT -lt $MAX_RETRIES ]; do
    # Petclinic health check endpoint
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/manage/health || true)
    if [ "$HTTP_CODE" == "200" ]; then
        echo "Service is healthy."
        exit 0
    fi
    echo "Waiting for service... (Attempt: $((COUNT+1)))"
    sleep 10
    COUNT=$((COUNT+1))
done

echo "Service failed to start."
docker-compose logs app
exit 1
