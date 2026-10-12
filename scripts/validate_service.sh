
#!/bin/bash
set -e

echo "Validating Petclinic service health..."

MAX_RETRIES=12
COUNT=0
HEALTH_URL="http://localhost/manage/health"

while [ "$COUNT" -lt "$MAX_RETRIES" ]; do
    HTTP_CODE=$(curl --connect-timeout 2 --max-time 5 \
        -s -o /dev/null -w "%{http_code}" \
        "$HEALTH_URL" || true)

    if [ "$HTTP_CODE" = "200" ]; then
        echo "Service is healthy."
        exit 0
    fi

    COUNT=$((COUNT + 1))
    echo "Health check returned HTTP ${HTTP_CODE:-000}. Attempt $COUNT/$MAX_RETRIES"

    if [ "$COUNT" -lt "$MAX_RETRIES" ]; then
        sleep 10
    fi
done

echo "Service failed to start. Container status:"
docker-compose ps || true

echo "Recent application logs:"
docker-compose logs --tail=100 app || true

exit 1
