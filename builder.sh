#!/bin/bash
LOCAL_DOCKER_NAME="devops/case"
CONTAINER_REGISTRY_URL="572820849697.dkr.ecr.eu-west-1.amazonaws.com/devops/case"

$(aws ecr get-login --no-include-email --region eu-west-1)

docker build -t ${LOCAL_DOCKER_NAME}:${GIT_COMMIT} ${WORKSPACE}

docker tag ${LOCAL_DOCKER_NAME}:${GIT_COMMIT} ${CONTAINER_REGISTRY_URL}:${GIT_COMMIT}

docker push ${CONTAINER_REGISTRY_URL}:${GIT_COMMIT}