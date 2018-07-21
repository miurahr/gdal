#!/bin/sh

set -e

export PATH=/usr/local/bin:$PATH

brew update
brew uninstall --ignore-dependencies postgis
brew uninstall --ignore-dependencies gdal
brew install sqlite3
brew install ccache swig
