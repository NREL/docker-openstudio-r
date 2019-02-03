# Docker OpenStudio R - Base Image

## 3.4.2-2 - 2018-10-30

* Add libgmp3-dev to dependencies to support newer DoE.base package
* Use new install_and_verify method for install R packages to actually test that the packages install correctly.
* Update the version schema to be with -<release>. Allows for different versions of dependencies based on the same version of R.

## 3.4.2 - 2018-03-09

* Base installation of dependencies and R packages
* This version is tagged as 3.4.2 retroactively.
