#!/bin/sh
set -e

# general dependencies
wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/FileGDB_API_1_2-64.tar.gz
wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz
wget http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-libecwj2-ubuntu12.04-64bit.tar.gz
tar xzf MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/include/* /usr/local/include
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/lib/* /usr/local/lib
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/include/* /usr/local/include
sudo cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/lib/* /usr/local/lib
tar xzf FileGDB_API_1_2-64.tar.gz
sudo cp -r FileGDB_API/include/* /usr/local/include
sudo cp -r FileGDB_API/lib/* /usr/local/lib
tar xzf install-libecwj2-ubuntu12.04-64bit.tar.gz
sudo cp -r install-libecwj2/include/* /usr/local/include
sudo cp -r install-libecwj2/lib/* /usr/local/lib
sudo ldconfig
