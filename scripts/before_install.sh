#!/bin/bash
set -e
echo "Cleaning up previous deployment..."
cd /opt/petclinic || mkdir -p /opt/petclinic
if [ -f "docker-compose.yml" ]; then
    docker-compose down || true
fi
rm -rf /opt/petclinic/*
