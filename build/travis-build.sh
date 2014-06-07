#!/bin/bash

set -ev

if [ "${TRAVIS_PULL_REQUEST}" != 'false' ]; then
    IS_NOT_PULL_REQUEST=false
    PULL_REQUEST=${TRAVIS_PULL_REQUEST}
else
    IS_NOT_PULL_REQUEST=true
fi

if [ "${TRAVIS_BRANCH}" == 'master' ]; then
    IS_MASTER=true
else
    IS_MASTER=false
    BRANCH_NAME=${TRAVIS_BRANCH}
fi

if [ IS_MASTER -a IS_NOT_PULL_REQUEST ]; then

    BUILD_NUMBER=${TRAVIS_BUILD_NUMBER}

    CURRENT_VERSION=$(mvn help:evaluate -Dexpression=project.version | grep -Ev '(^\[|Download\w+:)')
    NEW_VERSION=$(echo ${CURRENT_VERSION} | sed -e "s/-SNAPSHOT/\.$BUILD_NUMBER/")

    mvn versions:set -DnewVersion=${NEW_VERSION}
    mvn -N versions:update-child-modules
    mvn clean deploy
else
    mvn clean test
fi


