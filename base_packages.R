# *******************************************************************************
# OpenStudio(R), Copyright (c) 2008-2019, Alliance for Sustainable Energy, LLC.
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# (1) Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# (2) Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# (3) Neither the name of the copyright holder nor the names of any contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission from the respective party.
#
# (4) Other than as required in clauses (1) and (2), distributions in any form
# of modifications or other derivative works may not use the "OpenStudio"
# trademark, "OS", "os", or any other confusingly similar designation without
# specific prior written permission from Alliance for Sustainable Energy, LLC.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER, THE UNITED STATES
# GOVERNMENT, OR ANY CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# *******************************************************************************

# If changing this file, then it is recommended to update the version.R file as well
# to create a new release based on the updated dependencies.

# Function for installing and verifying that the package was installed correctly (i.e. can be loaded)
install_and_verify = function(package_name, configure.args=c(), repos=c('http://cloud.r-project.org','http://cran.r-project.org')){
    print(paste('Calling install for package ', package_name, sep=''))
    install.packages(package_name, configure.args=configure.args, repos=repos)
    if (!require(package_name, character.only = TRUE)){
        print('Error installing package, check log')
        quit(status=1)
    }
    print(paste('Successfully installed and test loaded ', package_name, sep=''))
}

# Install Base Packages
install_and_verify('R.methodsS3')
install_and_verify('R.oo')
install_and_verify('R.utils')
install_and_verify('Rcpp')
install_and_verify('rjson')
install_and_verify('RSQLite')
install_and_verify('RUnit')

# Data Manipulation
install_and_verify('plyr')
install_and_verify('reshape2')

# timeseries
install_and_verify('xts')

# plotting / visualization
install_and_verify('cowplot')
install_and_verify('ggplot2')
install_and_verify('ggsci')
install_and_verify('vcd')

# parallel processing
install_and_verify('doMC')
install_and_verify('doParallel')
install_and_verify('foreach')
install_and_verify('iterators')
