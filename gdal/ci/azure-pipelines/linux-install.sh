#!/bin/bash

set -e

export TZ=Europe/London
export DEBIAN_FRONTEND=noninteractive
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone


apt-get update
apt-get -y -q install software-properties-common apt-transport-https
add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
add-apt-repository -y ppa:ubuntu-toolchain-r/test

if [ $(lsb_release -sc) = "bionic" ]; then
  add-apt-repository -y 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main'
  apt-get update --allow-unauthenticated 
  apt-get install -y -q --allow-unauthenticated libjpeg-dev libgif-dev liblzma-dev libgeos-dev \
     libcurl4-gnutls-dev libproj-dev libxml2-dev  libxerces-c-dev libnetcdf-dev netcdf-bin \
     libpoppler-dev libpoppler-private-dev gpsbabel libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils \
     libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libcrypto++-dev libdap-dev libkml-dev \
     libmysqlclient-dev libogdi3.2-dev libarmadillo-dev wget libfyba-dev libjsoncpp-dev libexpat1-dev \
     libclc-dev ocl-icd-opencl-dev sqlite3-pcre libpcre3-dev libspatialite-dev libsfcgal-dev fossil libgeotiff-dev libcairo2-dev libjson-c-dev \
     python-dev python3-dev python-numpy python3-numpy python-lxml python3-lxml pyflakes python3-setuptools python-setuptools python-pip python3-pip python-virtualenv python3-venv \
     cmake ninja-build swig doxygen texlive-latex-base make cppcheck ccache g++ \
     clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8 libfuzzer-8-dev lldb-8 lld-8 \
     libpq-dev postgresql-10 postgresql-client-10 postgresql-10-postgis-2.5 postgresql-10-postgis-scripts libgdal20
elif [ $(lsb_release -sc) = "xenial" ]; then
  add-apt-repository -y 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main'
  add-apt-repository -y ppa:miurahr/gdal-depends-experimental
  apt-get update --allow-unauthenticated 
  apt-get install -y -q --allow-unauthenticated libjpeg-dev libgif-dev liblzma-dev libgeos-dev \
     libcurl4-gnutls-dev libproj-dev libxml2-dev  libxerces-c-dev libnetcdf-dev netcdf-bin \
     libpoppler-dev libpoppler-private-dev gpsbabel libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils \
     libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libcrypto++-dev libdap-dev libkml-dev \
     libmysqlclient-dev libogdi3.2-dev libarmadillo-dev wget libfyba-dev libjsoncpp-dev libexpat1-dev \
     libclc-dev ocl-icd-opencl-dev sqlite3-pcre libpcre3-dev libspatialite-dev libsfcgal-dev fossil libgeotiff-dev libcairo2-dev libjson-c-dev \
     python-dev python3-dev python-numpy python3-numpy python-lxml python3-lxml pyflakes python3-setuptools python-setuptools python-pip python3-pip python-virtualenv python3-venv \
     cmake ninja-build swig doxygen texlive-latex-base make cppcheck ccache g++ \
     clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8 libfuzzer-8-dev lldb-8 lld-8 \
     libpq-dev postgresql-9.5 postgresql-client-9.5 postgresql-9.5-postgis-2.4 postgresql-9.5-postgis-scripts libgdal20
elif [ $(lsb_release -sc) = "trusty" ]; then
  add-apt-repository -y 'deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-8 main'
  add-apt-repository -y ppa:miurahr/gdal-dev-additions
  apt-get update --allow-unauthenticated 
  apt-get install -y -q --allow-unauthenticated libjpeg-dev libgif-dev liblzma-dev libgeos-dev \
     libcurl4-gnutls-dev libproj-dev libxml2-dev  libxerces-c-dev libnetcdf-dev netcdf-bin \
     libpoppler-dev libpoppler-private-dev gpsbabel libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils \
     libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libcrypto++-dev libdap-dev libkml-dev \
     libmysqlclient-dev libogdi3.2-dev libarmadillo-dev wget libfyba-dev libjsoncpp-dev libexpat-dev \
     libclc-dev ocl-icd-opencl-dev sqlite3-pcre libpcre3-dev libspatialite-dev libsfcgal-dev fossil libgeotiff-dev libcairo2-dev libjson-c-dev \
     python-dev python3-dev python-numpy python3-numpy python-lxml python3-lxml pyflakes python3-setuptools python-setuptools python-pip python3-pip python-virtualenv python3.4-venv \
     cmake3 ninja-build swig doxygen texlive-latex-base make cppcheck ccache g++ \
     clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8 libfuzzer-8-dev lldb-8 lld-8 \
     libpq-dev postgresql-9.3 postgresql-client-9.3 postgresql-9.3-postgis-2.2 postgresql-9.3-postgis-scripts libgdal20 libpng12-dev libcfitsio3-dev
  wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/FileGDB_API_1_2-64.tar.gz
  wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-libecwj2-ubuntu12.04-64bit.tar.gz
  tar xzf FileGDB_API_1_2-64.tar.gz
  cp -r FileGDB_API/include/* /usr/local/include
  cp -r FileGDB_API/lib/* /usr/local/lib
  tar xzf install-libecwj2-ubuntu12.04-64bit.tar.gz
  cp -r install-libecwj2/include/* /usr/local/include
  cp -r install-libecwj2/lib/* /usr/local/lib
  ldconfig
fi