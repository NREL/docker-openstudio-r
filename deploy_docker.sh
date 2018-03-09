#!/usr/bin/env bash

IMAGETAG=skip
if [ "${TRAVIS_BRANCH}" == "develop" ]; then
    IMAGETAG=develop
elif [ "${TRAVIS_BRANCH}" == "master" ]; then
    IMAGETAG=$( docker run -it openstudio-r:latest printenv R_VERSION )
#    OUT=$?
#    if [ $OUT -eq 0 ]; then
#        IMAGETAG=$( echo $IMAGETAG | tr -d '\r' )
#        echo "Found R Version: $IMAGETAG"
#    else
#        echo "ERROR Trying to find R Version"
#        IMAGETAG=skip
#    fi
fi

if [ "${IMAGETAG}" != "skip" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    echo "Tagging image as $IMAGETAG"

    docker login -u $DOCKER_USER -p $DOCKER_PASS
    docker build -f Dockerfile -t nrel/openstudio-r:$IMAGETAG -t nrel/openstudio-r:latest .
    docker push nrel/openstudio-r:$IMAGETAG
    docker push nrel/openstudio-r:latest
else
    echo "Not on a deployable branch, this is a pull request or has been explicity skipped"
fi
