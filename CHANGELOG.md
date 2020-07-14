# Docker OpenStudio R - Base Image

## 3.6.1-1 - 2020-07-11

* Migrate base image to ubuntu 18.04

## 3.6.1 - 2019-10-21

* Upgrade to R 3.6.1

## 3.5.2-2 - 2018-10-30

* Upgrade base box to Ubuntu 16.04 (xenial)

## 3.5.2-1 - 2018-10-30

* Update to R 3.5.2

## 3.4.2-2 - 2018-10-30

* Add libgmp3-dev to dependencies to support newer DoE.base package
* Use new install_and_verify method for install R packages to actually test that the packages install correctly.
* Update the version schema to be with -<release>. Allows for different versions of dependencies based on the same version of R.

## 3.4.2 - 2018-03-09

* Base installation of dependencies and R packages
* This version is tagged as 3.4.2 retroactively.

