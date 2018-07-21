#!/bin/sh

set -e

# setup postgresql/postgis
# Pin to postgresql provided by ubuntugis.
echo "Package: *\nPin: release o=apt.postgresql.org,a=trusty-pgdg\nPin-Priority: -1\n" |sudo tee /etc/apt/preferences.d/ubuntugis-unstable-pin.pref @>&1 >/dev/null
sudo apt-get update -qq
sudo apt-get remove -qq libpq-dev libpq5 libgeos-dev libgeos-c1 \
  postgresql-9.2 postgresql-9.2-postgis-2.3-scripts \
  postgresql-9.3 postgresql-9.3-postgis-2.3-scripts \
  postgresql-9.4 postgresql-9.4-postgis-2.3-scripts \
  postgresql-9.5 postgresql-9.5-postgis-2.3-scripts \
  postgresql-9.6 postgresql-9.6-postgis-2.3-scripts \
  postgresql-client postgresql-client-9.2 \
  postgresql-client-9.3 postgresql-client-9.4 postgresql-client-9.5 postgresql-client-9.6 \
  postgresql-contrib-9.2 postgresql-contrib-9.3 \
  postgresql-contrib-9.4 postgresql-contrib-9.5 postgresql-contrib-9.6
sudo dpkg --add-architecture i386
 
# dependencies
sudo apt-get install -y -q --allow-unauthenticated python-numpy libpng12-dev libjpeg-dev libgif-dev liblzma-dev libgeos-dev \
 postgresql-9.3 postgresql-client-9.3 postgresql-9.3-postgis-2.2 postgresql-9.3-postgis-scripts  libgdal20 libpq-dev \
 libcurl4-gnutls-dev libproj-dev libxml2-dev libexpat1-dev libxerces-c-dev libnetcdf-dev netcdf-bin libpoppler-dev \
 libpoppler-private-dev gpsbabel libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils \
 libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libcrypto++-dev libdap-dev libfyba-dev \
 libkml-dev libmysqlclient-dev libogdi3.2-dev libcfitsio3-dev openjdk-8-jdk couchdb libarmadillo-dev \
 libclc-dev ocl-icd-opencl-dev sqlite3-pcre libpcre3-dev libspatialite-dev librasterlite2-dev libgta-dev \
 libsfcgal-dev fossil libgeotiff-dev libcharls-dev libopenjp2-7-dev libcairo2-dev python-numpy python-dev pyflakes libkea-dev \
 libjsoncpp-dev libjson-c-dev libogdi3.2-dev
