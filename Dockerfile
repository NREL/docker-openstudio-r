# AUTHOR:           Nicholas Long
# DESCRIPTION:      OpenStudio R Base Container

FROM ubuntu:18.04
MAINTAINER Nicholas Long nicholas.long@nrel.gov

# Install a bunch of dependencies for building R

RUN apt-get update \
      && apt-get install -y software-properties-common \
      && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
      && apt-get update \
      && apt-get install -y g++-7
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
        ruby2.5 \
        ruby-dev \
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
        libtcl8.5 \
        libtiff5-dev \
        libtk8.5 \
        libxml-libxml-perl \
        libxss1 \
        libxt-dev \
        mpack \
        tcl8.5 \
        tcl8.5-dev \
        tk8.5 \
        tk8.5-dev \
        ttf-adf-accanthis \
        ttf-adf-gillius \
    && rm -rf /var/lib/apt/lists/*

#### Build R and install R packages.
ENV R_VERSION 3.6.1
ENV R_MAJOR_VERSION 3
ENV R_SHA 5baa9ebd3e71acecdcc3da31d9042fb174d55a42829f8315f2457080978b1389
RUN curl -fSL -o R.tar.gz "http://cran.fhcrc.org/src/base/R-$R_MAJOR_VERSION/R-$R_VERSION.tar.gz" \
    && echo "$R_SHA R.tar.gz" | sha256sum -c - \
    && mkdir /usr/src/R \
    && tar -xzf R.tar.gz -C /usr/src/R --strip-components=1 \
	&& rm R.tar.gz \
	&& cd /usr/src/R \
    && sed -i 's/NCONNECTIONS 128/NCONNECTIONS 2560/' src/main/connections.c \
    && ./configure --enable-R-shlib CC=gcc-7 CXX=g++-7 \
    && make -j$(nproc) \
    && make install

# Add in the additional R packages
ADD /base_packages.R base_packages.R
RUN Rscript base_packages.R
ADD /version.R version.R

CMD [ "/usr/local/bin/R" ]
