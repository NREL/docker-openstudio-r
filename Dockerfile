# AUTHOR:           Nicholas Long
# DESCRIPTION:      OpenStudio R Base Container

FROM ubuntu:20.04
MAINTAINER Nicholas Long nicholas.long@nrel.gov

# Install a bunch of dependencies for building R

RUN apt-get update \
      && apt-get install -y software-properties-common \
      && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
      && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install tzdata
RUN apt-get install -y --no-install-recommends \
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

RUN curl -SLO https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.2.tar.gz \
    && tar -xvzf ruby-2.7.2.tar.gz \
    && cd ruby-2.7.2 \
    && ./configure \
    && make && make install 

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
    && ./configure --enable-R-shlib CC=gcc-9 CXX=g++-9 \
    && make -j$(nproc) \
    && make install

# Add in the additional R packages
ADD /base_packages.R base_packages.R
RUN Rscript base_packages.R
ADD /version.R version.R

CMD [ "/usr/local/bin/R" ]
