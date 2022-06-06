#!/usr/bin/env bash

IMAGETAG=skip
if [ "${GITHUB_REF}" == "refs/heads/develop" ]; then
    IMAGETAG=develop
elif [ "${GITHUB_REF}" == "refs/heads/master" ]; then
    VERSION=$( docker run openstudio-r:latest printenv R_VERSION )
    OUT=$?

    # Extended version (independent of $OUT)
    VERSION_EXT=$( docker run openstudio-r:latest Rscript version.R | grep -o '".*"' | tr -d '"' )

    if [ $OUT -eq 0 ]; then
        # strip off the \r that is in the result of the docker run command
        IMAGETAG=$( echo $VERSION | tr -d '\r' )$VERSION_EXT
        echo "Found Version: $IMAGETAG"
    else
        echo "ERROR Trying to find Version"
        IMAGETAG=skip
    fi
fi

# GITHUB_BASE_REF is only set on Pull Request events. Do not build those
if [ "${IMAGETAG}" != "skip" ] && [[ -z "${GITHUB_BASE_REF}" ]]; then
    echo "Tagging image as $IMAGETAG"

    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
    #Image has already been built from previous step so just tag it
    docker tag openstudio-r:latest nrel/openstudio:$IMAGETAG; (( exit_status = exit_status || $? ))
    docker tag openstudio-r:latest nrel/openstudio-r:latest; (( exit_status = exit_status || $? ))
    docker push nrel/openstudio-r:$IMAGETAG
    docker push nrel/openstudio-r:latest
else
    echo "Not on a deployable branch, this is a pull request or has been explicity skipped"
fi
