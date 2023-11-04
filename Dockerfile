# AUTHOR:           Nicholas Long
# DESCRIPTION:      OpenStudio R Base Container

FROM ubuntu:22.04
MAINTAINER Nicholas Long nicholas.long@nrel.gov

# Install a bunch of dependencies for building R
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
        && apt-get install -y software-properties-common \
        && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
        && apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        bison \
        build-essential \
        bzip2 \
        ca-certificates \
        curl \
        imagemagick \
        gdebi-core \
        git \
        libbz2-dev \
        libcurl4-openssl-dev \
        libgdbm-dev \
        libglib2.0-dev \
        libncurses-dev \
        libreadline-dev \
        libxml2-dev \
        libxslt-dev \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
        libgmp3-dev \
        procps \
        sudo \
        tar \
        tzdata \
        unzip \
        wget \
        zip \
        zlib1g-dev \
        debhelper \
        fonts-cabin \
        fonts-comfortaa \
        fonts-droid-fallback \
        fonts-font-awesome \
        fonts-freefont-otf \
        fonts-freefont-ttf \
        fonts-gfs-artemisia \
        fonts-gfs-complutum \
        fonts-gfs-didot \
        fonts-gfs-neohellenic \
        fonts-gfs-olga \
        fonts-gfs-solomos \
        fonts-inconsolata \
        fonts-junicode \
        fonts-lato \
        fonts-linuxlibertine \
        fonts-lobster \
        fonts-lobstertwo \
        fonts-oflb-asana-math \
        fonts-sil-gentium \
        fonts-sil-gentium-basic \
        fonts-stix \
        gfortran \
        gir1.2-freedesktop \
        gir1.2-pango-1.0 \
        libblas3 \
        libcairo-script-interpreter2 \
        libcairo2-dev \
        libgs9 \
        libintl-perl \
        libjbig-dev \
        libjpeg-dev \
        libkpathsea6 \
        liblapack-dev \
        liblzma-dev \
        libtiff5-dev \
        libxml-libxml-perl \
        libxss1 \
        libxt-dev \
        mpack \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Start by installing openssl 1.1.1o" &&\
    wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1o.tar.gz &&\
    tar xfz openssl-1.1.1o.tar.gz && cd openssl-1.1.1o &&\
    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl '-Wl,-rpath,$(LIBRPATH)' &&\
    make --quiet -j $(nproc) && make install --quiet && rm -Rf openssl-1.1.o* &&\
    rm -rf /usr/local/ssl/certs &&\
    ln -s /etc/ssl/certs /usr/local/ssl/certs

RUN echo "Installing Ruby 2.7.2 via RVM" &&\
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - &&\
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - &&\
    curl -sSL https://get.rvm.io | bash -s stable &&\
    usermod -a -G rvm root &&\
    /usr/local/rvm/bin/rvm install 2.7.2 --with-openssl-dir=/usr/local/ssl/ -- --enable-static &&\
    /usr/local/rvm/bin/rvm --default use 2.7.2

ENV PATH="/usr/local/rvm/rubies/ruby-2.7.2/bin:${PATH}"

#### Build R and install R packages.
ENV R_VERSION 4.2.0
ENV R_MAJOR_VERSION 4
ENV R_SHA 38eab7719b7ad095388f06aa090c5a2b202791945de60d3e2bb0eab1f5097488
RUN curl -fSL -o R.tar.gz "http://cran.r-project.org/src/base/R-$R_MAJOR_VERSION/R-$R_VERSION.tar.gz" \
    && echo "$R_SHA R.tar.gz" | sha256sum -c - \
    && mkdir /usr/src/R \
    && tar -xzf R.tar.gz -C /usr/src/R --strip-components=1 \
	&& rm R.tar.gz \
	&& cd /usr/src/R \
    && sed -i 's/NCONNECTIONS 128/NCONNECTIONS 2560/' src/main/connections.c \
    && ./configure --enable-R-shlib CC=gcc-11 CXX=g++-11 \
    && make -j$(nproc) \
    && make install

# Add in the additional R packages
ADD /base_packages.R base_packages.R
RUN Rscript base_packages.R
ADD /version.R version.R

CMD [ "/usr/local/bin/R" ]
