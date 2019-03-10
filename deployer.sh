#!/bin/bash
SERVICE_NAME="flask-service"
IMAGE_VERSION=${DOCKER_TAG}
TASK_FAMILY="first-run-task-definition"
## export AWS_DEFAULT_REGION="eu-west-1"

# Create a new task definition for this build
sed -e "s;%DOCKER_TAG%;${IMAGE_VERSION};g" flask-fargate.json > flask-fargate-${IMAGE_VERSION}.json
aws ecs register-task-definition --family first-run-task-definition --cli-input-json file://flask-fargate-${IMAGE_VERSION}.json --region eu-west-1

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition first-run-task-definition --region eu-west-1 | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/,*$//g'`
DESIRED_COUNT=`aws ecs describe-services --services flask-service --cluster python-cluster --region eu-west-1 | egrep "desiredCount" | head -n 1 | awk '{print $2}' | sed 's/,$//'`
if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi

aws ecs update-service --cluster python-cluster --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT} --region eu-west-1