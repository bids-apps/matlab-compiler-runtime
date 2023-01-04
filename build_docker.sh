#! /bin/bash

# used to build the Docker image for a project in circle CI

git describe --tags --always > version
docker build -t "bids/${CIRCLE_PROJECT_REPONAME,,}" .
mkdir -p ${HOME}/docker
docker save "bids/${CIRCLE_PROJECT_REPONAME,,}" > ~/docker/image.tar
# persist guessed branch so we can use it in deploy/tag
BRANCH=$(git branch --contains tags/${CIRCLE_TAG})
echo -n "${BRANCH}" > ~/docker/branch
