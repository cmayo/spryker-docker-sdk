#!/bin/bash

import sdk/images/baked.sh

function Images::buildApplication() {
    Console::verbose "${INFO}Building application images for AWS ECR${NC}"

    Images::_buildApp baked ${TRUE}
}

function Images::buildFrontend() {
    Console::verbose "${INFO}Building Frontend image for AWS ECR${NC}"

    Images::_buildFrontend baked
    Images::_buildGateway
}

function Images::tagApplications() {
    local tag=${1:-${SPRYKER_DOCKER_TAG}}

    Console::verbose "${INFO}Tag images for AWS ECR${NC}"
    for application in "${SPRYKER_APPLICATIONS[@]}"; do
        local application="$(echo "$application" | tr '[:upper:]' '[:lower:]')"
        docker tag "${SPRYKER_DOCKER_PREFIX}_app:${tag}" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-${application}:latest"
    done

    # docker tag $${INIT_IMAGE_PREFIX}_app:1.0-yves  $${YVES_ECR_REPO}:$${DESIRED_IMAGE_TAG}
    # 262925510123.dkr.ecr.eu-west-1.amazonaws.com/khanko-staging-jenkins

    # Debug calls
    Console::error "*****************************TAG APPLICATIONS********************************"
    Console::error "SPRYKER_DOCKER_PREFIX: ${SPRYKER_DOCKER_PREFIX} tag: ${tag}"
    Console::error "AWS_ACCOUNT_ID: ${AWS_ACCOUNT_ID} AWS_REGION: ${AWS_REGION} SPRYKER_PROJECT_NAME: ${SPRYKER_PROJECT_NAME}"

    docker tag "${SPRYKER_DOCKER_PREFIX}_jenkins:${tag}" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-jenkins:latest"
    docker tag "${SPRYKER_DOCKER_PREFIX}_pipeline:${tag}" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-pipeline:latest"
}

function Images::tagFrontend() {
    Console::verbose "${INFO}Tagging Frontend for AWS ECR${NC}"

    local tag=${1:-${SPRYKER_DOCKER_TAG}}

    docker tag "${SPRYKER_DOCKER_PREFIX}_frontend:${tag}" "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-frontend:latest"
}

function Images::push() {
    Console::verbose "${INFO}Pushing images to AWS ECR${NC}"

    # Debug calls
    Console::error "*******************PUSH FUNCTION**********************"

    docker images | grep ecr
    for application in "${SPRYKER_APPLICATIONS[@]}"; do
        local application="$(echo "$application" | tr '[:upper:]' '[:lower:]')"
        echo "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-${application}:latest"
#        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-${application}:latest
    done
#        docker push "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-frontend:latest"
#        docker push "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-jenkins:latest"
#        docker push "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-pipeline:latest"

        echo "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-frontend:latest"
        echo "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-jenkins:latest"
        echo "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SPRYKER_PROJECT_NAME}-pipeline:latest"
}
