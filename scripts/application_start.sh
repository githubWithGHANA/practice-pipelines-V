#!/bin/bash
set -e

# Read deployment values from Parameter Store only
export AWS_DEFAULT_REGION=$(aws ssm get-parameter --name "/petclinic/AWS_DEFAULT_REGION" --query "Parameter.Value" --output text)
export ACCOUNT_ID=$(aws ssm get-parameter --name "/petclinic/ACCOUNT_ID" --query "Parameter.Value" --output text)
export IMAGE_REPO_NAME=$(aws ssm get-parameter --name "/petclinic/IMAGE_REPO_NAME" --query "Parameter.Value" --output text)
export MYSQL_ROOT_PASSWORD=$(aws ssm get-parameter --name "/petclinic/DB_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
export IMAGE_TAG=$(aws ssm get-parameter --name "/petclinic/IMAGE_TAG" --query "Parameter.Value" --output text)

cd /opt/petclinic
docker-compose up -d
