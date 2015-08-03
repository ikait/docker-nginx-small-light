FROM ubuntu:14.04


ENV WORKDIR /src
#ENV NGINX_VER 1.8.0
ENV NGINX_VER 1.4.4
ENV IMAGEMAGICK_VER 6.9.1-2
ENV LIBGD_VER 2.1.1
# ENV IMLIB2_VER 1.4.7
ENV IMLIB2_VER 1.4.2
ENV NGX_SMALL_LIGHT_VER 0.6.8


RUN \
  apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive


WORKDIR $WORKDIR


RUN \
  apt-get install -y \
    wget \
    tar \
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
  wget -O- http://launchpad.net/imagemagick/main/${IMAGEMAGICK_VER}/+download/ImageMagick-${IMAGEMAGICK_VER}.tar.gz | \
  tar xz && \
  cd ImageMagick-${IMAGEMAGICK_VER} && \
  ./configure && \
  make && \
  make install && \
  ldconfig /usr/local/lib && \
  apt-get clean


# gd

RUN \
  wget -O- https://bitbucket.org/libgd/gd-libgd/downloads/libgd-${LIBGD_VER}.tar.gz | tar xvz && \
  cd libgd-${LIBGD_VER} && \
  ./configure && \
  make && \
  make install && \
  ldconfig /usr/local/lib


# imlib2

RUN \
  apt-get install -y \
    libfreetype6-dev && \
  wget -O- http://downloads.sourceforge.net/project/enlightenment/imlib2-src/${IMLIB2_VER}/imlib2-${IMLIB2_VER}.tar.bz2 | \
  tar xj && \
  cd imlib2-${IMLIB2_VER} && \
  ./configure --without-x && \
  make && \
  make install && \
  ldconfig /usr/local/lib && \
  apt-get clean


# ngx_small_light

RUN \
  apt-get install -y \
    libpcre3-dev && \
  wget -O- https://github.com/cubicdaiya/ngx_small_light/archive/v${NGX_SMALL_LIGHT_VER}.tar.gz | \
  tar xz && \
  cd ngx_small_light-${NGX_SMALL_LIGHT_VER} && \
  ./setup --with-imlib2 --with-gd && \
  ldconfig /usr/local/lib && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/


# nginx

RUN \
  apt-get install -y \
    libx11-dev && \
  wget -O- https://github.com/nginx/nginx/archive/release-${NGINX_VER}.tar.gz | \
  tar xz && \
  cp -p nginx-release-${NGINX_VER}/auto/configure nginx-release-${NGINX_VER}/configure && \
  cd nginx-release-${NGINX_VER} && \
  ./configure --add-module=${WORKDIR}/ngx_small_light-${NGX_SMALL_LIGHT_VER} && \
  make && \
  make install && \
  ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx && \
  apt-get clean


# clean

RUN \
  rm -rf /var/lib/apt/lists/


COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY index.html /usr/local/nginx/html/index.html


EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]
