#! /bin/bash

# used to push the Docker image for a project in circle CI

if [[ -n "${CIRCLE_TAG}" ]]; then

    echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin

    # tag should always be X.Y.Z[-variant]
    docker tag "bids/${CIRCLE_PROJECT_REPONAME,,}" "bids/${CIRCLE_PROJECT_REPONAME,,}:${CIRCLE_TAG}"
    docker push "bids/${CIRCLE_PROJECT_REPONAME,,}:${CIRCLE_TAG}"

    # also publish tag for the corresponding matlab release version, which is the name of the current branch
    docker "tag bids/${CIRCLE_PROJECT_REPONAME,,}" "bids/${CIRCLE_PROJECT_REPONAME,,}:${BRANCH}"
    docker push "bids/${CIRCLE_PROJECT_REPONAME,,}:${BRANCH}"
    BRANCH=$(cat /tmp/workspace/docker/branch)

    # update major tag X.Y[-variant] to the latest in this branch
    MAJOR_TAG=$(echo "${CIRCLE_TAG}" | sed -rn 's#([[:digit:]]+).([[:digit:]]+).([[:digit:]]+)(.*)#\1.\2\4#p')
    if [[ -n "${MAJOR_TAG}" ]] ; then
    docker tag "bids/${CIRCLE_PROJECT_REPONAME,,}" "bids/${CIRCLE_PROJECT_REPONAME,,}:${MAJOR_TAG}"
    docker push "bids/${CIRCLE_PROJECT_REPONAME,,}:${MAJOR_TAG}"
    fi

fi
