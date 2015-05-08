FROM ubuntu:14.04

RUN \
  apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive

ENV WORKDIR="/src"

WORKDIR $WORKDIR

RUN \
  apt-get install -y \
    wget \
    tar \
    git \
    gcc \
    make \
    gzip \
    bzip2

RUN \
  export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH


# imagemagick

RUN \
  apt-get install -y \
    libimlib2-dev \
    libjpeg-turbo8-dev \
    libwebp-dev \
    libpng12-dev \
    libgif-dev \
    libtiff5-dev && \
  wget http://www.imagemagick.org/download/ImageMagick.tar.gz && \
  tar xvzf ImageMagick.tar.gz && \
  cd ImageMagick-6.9.1-2 && \
  ./configure && \
  make && \
  make install && \
  ldconfig /usr/local/lib


# gd

RUN \
  wget https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.1.tar.gz && \
  tar xvzf libgd-2.1.1.tar.gz && \ 
  cd libgd-2.1.1 && \ 
  ./configure && \
  make && \
  make install && \
  ldconfig /usr/local/lib


# imlib2

RUN \
  apt-get install -y \
    libfreetype6-dev && \
  wget http://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.7/imlib2-1.4.7.tar.bz2 && \
  tar xvjf imlib2-1.4.7.tar.bz2 && \
  cd imlib2-1.4.7 && \
  ./configure --without-x && \
  make && \
  make install && \
  ldconfig /usr/local/lib


# ngx_small_light

RUN \
  apt-get install -y \
    libpcre3-dev && \
  git clone https://github.com/cubicdaiya/ngx_small_light.git && \
  cd ngx_small_light && \
  ./setup --with-imlib2 --with-gd && \
  ldconfig /usr/local/lib


# nginx

RUN \
  apt-get install -y \
    libx11-dev && \
  wget http://nginx.org/download/nginx-1.6.3.tar.gz && \
  tar xvzf nginx-1.6.3.tar.gz && \
  cd nginx-1.6.3 && \
  ./configure --add-module=${WORKDIR}/ngx_small_light && \
  make && \
  make install && \
  ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx


COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY index.html /usr/local/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
