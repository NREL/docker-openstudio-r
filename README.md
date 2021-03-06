# OpenStudio-R

[![Build Status](https://travis-ci.org/NREL/docker-openstudio-r.svg?branch=master)](https://travis-ci.org/NREL/docker-openstudio-r)

Base image for using R in OpenStudio Server. Includes default Ruby as well.

### Build

Installing the [docker tool-kit](https://docs.docker.com/engine/installation/) version 17.03.1 or later, as described in the linked documentation. Once the tool-kit is installed and activated, run the command `docker build .`. This will initiate the build process for the docker container. Any updates to this process should be implemented through the [Dockerfile](./Dockerfile) in the root of this repo. 

The builds will be posted to [Docker Hub](https://hub.docker.com/repository/docker/nrel/openstudio-r). Builds from the `master` branch will result in newly tagged versions (e.g., 3.6.1) and builds from the `develop` branch will be tagged as develop.

# Known Issues

Please submit issues on the project's [Github](https://github.com/nrel/docker-openstudio-r) page. 
